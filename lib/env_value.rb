require "env_value/version"

module Kernel
  # Get a boolean or string value from the specified ENV variable.  '1', 'true', '0', 'false' will
  # be converted to boolean values; all values others as string values (returned as-is, since ENV
  # only contains string values).
  #
  # See ENV_boolean for more available options.
  #
  def ENV_value(key, convert: :string, **options)
    ENV_boolean(key, invalid: convert, **options)
  end

  # Get a boolean value (true or false) from the specified ENV variable.
  #
  # By default, '1', 'true' will be treated as true values; '0', 'false' as false values;
  # and all others as nil.
  # You can configure that with the `true:`, `false:`, and `default:` (or
  # `missing:`/`invalid:`) options.
  #
  # @example
  #   ENV['enabled'] = '1'
  #   ENV['skip_it'] = 'skip'
  #
  #   ENV_boolean('enabled')                 # => true
  #   ENV_boolean('skip_it')                 # => nil
  #   ENV_boolean('unknown')                 # => nil
  #   ENV_boolean('unknown', default: true)  # => true
  #
  #   ENV_boolean('skip_it', default: false)    # => false
  #   ENV_boolean('skip_it', false: ['skip'])   # => false
  #   ENV_boolean('skip_it', true:  ['skip'])   # => true
  #   ENV_boolean('skip_it', invalid: :string)  # => 'skip'
  #
  # @example
  #   You can rewrite this:
  #     Capybara.javascript_driver = ENV['javascript_driver'].to_sym if ENV['javascript_driver']) || :firefox
  #   into this slightly more readable and shorter:
  #     Capybara.javascript_driver = ENV_value('javascript_driver', convert: :to_sym, default: :firefox)
  #
  def ENV_boolean(
    key,
    true:         [],
    false:        [],
    # By default the true: and false: options get appended to the internal defaults, but you can
    # override internal defaults, too, if you want. 
    true_values:  ['1', 'true' ] + Array(binding.local_variable_get('true')),
    false_values: ['0', 'false'] + Array(binding.local_variable_get('false')),
    default: nil,
    missing: default,  # (missing_default)
    invalid: default   # (invalid_default)
  )
    unless ENV.key?(key)
      if [:raise, :fail, :abort].include? missing
        message = %(Environment variable "#{key}" was missing.)
        send(missing, message)
      else
        return missing
      end
    end

    allowed_values = true_values + false_values
    value = ENV[key]
    case value
    when *true_values; true
    when *false_values; false
    else
      if    [:string, :to_s].include?(invalid)
        value
      elsif [:symbol, :to_sym].include?(invalid)
        value.to_sym
      elsif [:integer, :to_i].include?(invalid)
        value.to_i
      elsif [:raise, :fail, :abort].include?(invalid)
        message = %(Environment variable "#{key}" (#{value.inspect}) was not one of the allowed values (#{allowed_values}).)
        send(invalid, message)
      else
        invalid
      end
    end
  end
  alias_method :ENV_boolean_value, :ENV_boolean

  # TODO: API idea, so you can use more natural [] index access syntax:
  #   ENV.boolean['a']

  # Previous version:
  #
  # (Probably don't need these if we have ENV_boolean.)
  #
  # def ENV_value_truthy?(key, default: nil)
  #   return default unless ENV.key?(key)
  #
  #   value = ENV[key]
  #   value.in? ['1', 'true']
  # end
  #
  # def ENV_value_falsey?(key, default: nil)
  #   return default unless ENV.key?(key)
  #
  #   value = ENV[key]
  #   value.in? ['0', 'false']
  # end

end
