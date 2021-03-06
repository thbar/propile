# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'rubygems'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'rspec/autorun'
require 'factory_girl_rails'
require 'shoulda/matchers'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.include ControllerExtensions, :type => :controller
  config.include Shoulda::Matchers::ActiveModel

  # capyabara needs it false or else records won't appear in phantomjs server
  # https://github.com/jnicklas/capybara#transactions-and-database-setup
  config.use_transactional_fixtures = false

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false
  config.filter_run_including :focus => true
  config.filter_run_excluding :broken => true
  config.filter_run 
  config.run_all_when_everything_filtered = true

  config.treat_symbols_as_metadata_keys_with_true_values = true

  config.before(:suite) do
    DatabaseCleaner.strategy = :deletion
    DatabaseCleaner.clean_with( :truncation )
  end

  config.before :each do
    DatabaseCleaner.start
  end

  config.after :each do
    DatabaseCleaner.clean
  end

  config.include FactoryGirl::Syntax::Methods
  config.include RequestUserHelpers, type: :feature
end

Capybara.configure do |config|
  config.default_driver = :poltergeist
end
