require 'test_helper'

class BitSettingsTest < Minitest::Test#Minitest::Unit::TestCase

  def setup
    User.delete_all
  end

  def test_instance_methods
    u = User.new
    assert !u.disable_notifications?
    assert !u.help_tour_shown?
    u.disable_notifications = true
    assert u.disable_notifications?
    u.save!
    u = User.last
    assert u.disable_notifications
  end

  def test_instance_methods_with_column_and_prefix
    u = User.new
    assert u.conf_conf1?
    assert u.conf_conf2?
    u.conf_conf1 = false
    assert !u.conf_conf1?
    u.save!
    u = User.last
    assert !u.conf_conf1
  end

  def test_scope
    u1 = User.create(username: 'user1')
    u2 = User.create(username: 'user2', disable_notifications: true, conf_conf1: false)
    u3 = User.create(username: 'user3', help_tour_shown: true, conf_conf2: false)
    u4 = User.create(username: 'user4', disable_notifications: true, conf_conf2: false)
    u5 = User.create(username: 'user5', help_tour_shown: true, conf_conf1: false)
    u6 = User.create(username: 'user6', disable_notifications: true, conf_conf1: false, help_tour_shown: true, conf_conf2: false)

    res = User.with_settings(disable_notifications: true)
    assert_equal [u2, u4, u6], res.to_a

    res = User.with_settings(disable_notifications: false, help_tour_shown: true)
    assert_equal [u3, u5], res.to_a

    res = User.with_settings(help_tour_shown: true)
    res.to_sql
    assert_equal [u3, u5, u6], res.to_a

    res = User.with_settings(help_tour_shown: false)
    assert_equal [u1, u2, u4], res.to_a    
    
    res = User.with_settings(disable_notifications: false, help_tour_shown: false)
    assert_equal [u1], res.to_a

    res = User.with_settings(disable_notifications: true, conf_conf1: false)
    assert_equal [u2, u6], res.to_a

    res = User.with_settings(conf_conf1: true)
    assert_equal [u1, u3, u4], res.to_a

    res = User.with_settings(conf_conf1: true, conf_conf2: true)
    assert_equal [u1], res.to_a

    res = User.with_settings(disable_notifications: true, help_tour_shown: false, conf_conf1: true, conf_conf2: true)
    assert_equal [], res.to_a

    res = User.with_settings({})
    assert_equal [u1, u2, u3, u4, u5, u6], res.to_a
  end

  def test_raise_if_invalid_setting
    assert_raises do
      User.with_settings(invalid: true)
    end
  end

end