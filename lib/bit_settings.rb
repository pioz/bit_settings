require 'bit_settings/version'

module BitSettings

  def self.included(base)
    base.extend(self)
  end

  def add_settings(settings:, column: :settings, prefix: nil)
    prefix = prefix ? "#{prefix}_" : ''
    if settings.size > 32
      raise 'You can NOT have more than 32 settings (max unsigned int with 4 bytes is 2^32-1)'
    else
      settings.each_with_index do |setting, i|
        define_method "#{prefix}#{setting}" do
          self.send(column) & (1 << i) > 0
        end
        alias_method "#{prefix}#{setting}?", "#{prefix}#{setting}"
        define_method "#{prefix}#{setting}=" do |value|
          if ActiveModel::Type::Boolean.new.cast(value)
            self.send("#{column}=", self.send(column) | (1 << i))
          else
            self.send("#{column}=", self.send(column) & ~(1 << i))
          end
        end
      end
    end
  end

end
