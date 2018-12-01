# This file is copied to spec/ when you run 'rails generate rspec:install'

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require 'support/simplecov'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!
require 'support/factory_bot'
require 'support/shoulda'
require 'support/database_cleaner'
require 'support/helpers/form'
require 'support/devise_routing'

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.include FactoryBot

  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::ControllerHelpers, type: :view
  config.include Devise::Test::IntegrationHelpers, type: :feature

  config.include Helpers::Form, type: :feature

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.include DeviseRoutingHelpers, type: :routing

  config.before(:each, type: :routing) do
    mock_warden_for_route_tests!
  end
end
