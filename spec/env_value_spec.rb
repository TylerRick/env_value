RSpec.describe EnvValue do
  it "ENV_value" do
    ENV['option'] = nil
    expect{ENV_value('option', missing: :raise)}.to raise_error('Environment variable "option" was missing.')

    ENV['option'] = 'sanely'
    expect(ENV_value('option')                  ).to eq 'sanely'
    expect(ENV_value('option', convert: :to_sym)).to eq :sanely

    ENV['max_attempts'] = '3'
    expect(ENV_value('max_attempts')                ).to eq '3'
    expect(ENV_value('max_attempts', convert: :to_i)).to eq  3
  end

  it "ENV_boolean" do
    ENV['unknown'] = nil
    ENV['enabled'] = '1'
    ENV['skip_it'] = 'skip'

    expect(ENV_boolean('enabled')                ).to eq true
    expect(ENV_boolean('skip_it')                ).to eq nil
    expect(ENV_boolean('unknown')                ).to eq nil
    expect(ENV_boolean('unknown', default: true) ).to eq true
    expect(ENV_boolean('unknown', missing: true) ).to eq true

    expect(ENV_boolean('skip_it', default: false) ).to eq false
    expect(ENV_boolean('skip_it', false: ['skip'])).to eq false
    expect(ENV_boolean('skip_it', true:  ['skip'])).to eq true
    expect(ENV_boolean('skip_it', missing: true, invalid: :string)).to eq 'skip'
  end
end
