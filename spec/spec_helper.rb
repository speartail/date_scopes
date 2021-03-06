require 'rubygems'
require 'bundler/setup'
require 'factory_girl'
require 'timecop'

require 'simplecov'
SimpleCov.start do
  add_filter '/spec/support/'
  add_filter 'spec_support.rb'
end

require 'simple_date_scopes'
Dir[File.join(%w[ . spec support ** *.rb])].each {|f| require f}
require 'simple_date_scopes/spec_support'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.mock_with :rspec

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  config.include FactoryGirl::Syntax::Methods

  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end

end
