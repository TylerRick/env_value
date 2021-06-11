# EnvValue

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'env_value'
```

And then execute:

    $ bundle install

## Usage

### `ENV_value`

Get a boolean or string value from the specified ENV variable.  '1', 'true', '0', 'false' will
be converted to boolean values; all values others as string values (returned as-is, since ENV
only contains string values).

```ruby
  ENV_value('option', missing: :raise)  # raises 'Environment variable "option" was missing.'

  ENV['option'] = 'sanely'
  ENV_value('option')                   # => 'sanely'
  ENV_value('option', convert: :to_sym) # => :sanely
```

```ruby
  ENV['max_attempts'] = '3'
  ENV_value('max_attempts')                 # => '3'
  ENV_value('max_attempts', convert: :to_i) # =>  3
```

See ENV_boolean for more available options.

### `ENV_boolean`

Get a boolean value (true or false) from the specified ENV variable.

By default, '1', 'true' will be treated as true values; '0', 'false' as false values;
and all others as nil.

You can configure that with the `true:`, `false:`, and `default:` (or
`missing:`/`invalid:`) options.

```ruby
  ENV['enabled'] = '1'
  ENV['skip_it'] = 'skip'

  ENV_boolean('enabled')                 # => true
  ENV_boolean('skip_it')                 # => nil
  ENV_boolean('unknown')                 # => nil
  ENV_boolean('unknown', default: true)  # => true
  ENV_boolean('unknown', missing: true)  # => true

  ENV_boolean('skip_it', default: false)    # => false
  ENV_boolean('skip_it', false: ['skip'])   # => false
  ENV_boolean('skip_it', true:  ['skip'])   # => true
  ENV_boolean('skip_it', missing: true, invalid: :string)  # => 'skip'
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/TylerRick/env_value.

