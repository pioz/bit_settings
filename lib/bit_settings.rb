require 'bit_settings/version'
require 'bit_settings/boolean_value'

module BitSettings
  extend ActiveSupport::Concern
  
  included do
    class_attribute :bit_settings

    scope :with_settings, lambda { |h|
      available = self.bit_settings.values.flatten
      invalid = h.keys - available
      raise "Settings #{invalid.inspect} do not exist for #{self} model: available settings are #{available.inspect}" if invalid.any?
      scope = current_scope
      self.bit_settings.each do |column, settings|
        true_mask  = h.select{|k, v| settings.include?(k) &&  v}.keys.reduce(0) {|memo, x| memo | (1 << settings.index(x))}
        false_mask = h.select{|k, v| settings.include?(k) && !v}.keys.reduce(0) {|memo, x| memo | (1 << settings.index(x))}
        scope = scope.where("#{table_name}.#{column} & #{true_mask} = #{true_mask}") if  true_mask > 0
        scope = scope.where("#{table_name}.#{column} & #{false_mask} = 0") if false_mask > 0
      end
      return scope
    }

  end

  module ClassMethods

    def add_settings(*settings, column: :settings, prefix: nil)
      prefix = prefix ? "#{prefix}_" : ''
      if settings.size > 32
        raise 'You can NOT have more than 32 settings (max unsigned int with 4 bytes is 2^32-1)'
      else

        self.bit_settings ||= {}
        self.bit_settings[column] = settings.map{|x| "#{prefix}#{x}".to_sym}

        cast_to_boolean = BooleanValue.cast_to_boolean_func

        settings.each_with_index do |setting, i|
          define_method "#{prefix}#{setting}" do
            self.send(column) & (1 << i) > 0
          end
          alias_method "#{prefix}#{setting}?", "#{prefix}#{setting}"
          
          define_method "#{prefix}#{setting}=" do |value|
            if cast_to_boolean.call(value)
              self.send("#{column}=", self.send(column) | (1 << i))
            else
              self.send("#{column}=", self.send(column) & ~(1 << i))
            end
          end
        end

      end
    end

  end

end
