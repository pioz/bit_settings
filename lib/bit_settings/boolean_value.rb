module BooleanValue

  FALSE_VALUES = [false, 0, '0', 'f', 'F', 'false', 'FALSE', 'off', 'OFF']

  def self.cast_to_boolean_func

    major, minor, _ = ActiveModel.version.to_s.split('.').map(&:to_i)
    case major
    # Rails 5
    when 5
      return ->(value) { ActiveModel::Type::Boolean.new.cast(value) }
    # Rails 4.2
    when 4
      if minor >= 2
        return ->(value) { ActiveRecord::Type::Boolean.new.type_cast_from_user(value) }
      end
    end
    return ->(value) { value == '' ? nil : !FALSE_VALUES.include?(value) }
  end

end