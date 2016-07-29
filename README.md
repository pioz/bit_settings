# BitSettings

BitSettings is a plugin for ActiveRecord that transform a column of your model in a set of boolean settings.
You can have up to 32 boolean values stored in a single database column.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bit_settings'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bit_settings

## Usage

First of all add a unsigned int column for your boolean settings with `rails g migration add_settings_to_users settings:integer` and then edit like follow:


```
class AddSettingsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :settings, 'INT UNSIGNED', null: false, default: 0
  end
end
```
The max unsigned integer in 4 bytes is `2^32-1 = 4294967295` so with a column you can have max 32 settings.
If you want that the default value of your settings is 1 (true) set the default value of the column to `2^32-1`.

Then in your model:

```
class User extends ActiveRecord::Base
  include BitSettings
  add_settings settings: [:disable_notifications, :help_tour_shown]
end
```

Now you can do:

```
user.disable_notifications? # => false
user.help_tour_shown? # => false
user.disable_notifications = true # => true
user.save
```

Other options are `:column` and `:prefix`:

```
class User extends ActiveRecord::Base
  add_settings settings: [:disable_notifications, :help_tour_shown], column: :my_settings, prefix: :setting
end
```
* `:column` specify the name of the column to use (default is `settings`)
* `:prefix` add a prefix to dynamic methods

```
user.setting_disable_notifications? # => false
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pioz/bit_settings.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
