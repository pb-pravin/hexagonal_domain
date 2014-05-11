require 'coveralls'
Coveralls.wear!

# Gem dependencies
require 'rspec'
require 'rspec/autorun'

# Gem files
lib = File.dirname File.dirname(__FILE__)
Dir[File.join(lib, "lib", "**", "*.rb")].each{ |f| require f }

RSpec.configure do |config|

  # Use rspec for mocking and stubbing
  config.mock_with :rspec

  # Run tests in a random order
  config.order = "random"

  # Run only tests tagged by :focus (focus: true)
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
