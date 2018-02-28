require 'minitest/autorun'
require 'sqlite3'
require 'active_record'
require 'bit_settings'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

ActiveRecord::Schema.define do
  create_table(:users) do |t|
    t.string :username
    t.column :settings, 'INT UNSIGNED', null: false, default: 0
    t.column :conf,     'INT UNSIGNED', null: false, default: 2**31-1
  end
end

class User < ActiveRecord::Base
  include BitSettings
  add_settings :disable_notifications, :help_tour_shown
  add_settings :conf1, :conf2, column: :conf, prefix: :conf
end