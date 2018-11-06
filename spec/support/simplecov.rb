if ENV['RAILS_ENV'] == 'test'
  require 'simplecov'
  require 'simplecov-console'
  SimpleCov.formatter = SimpleCov::Formatter::Console
  SimpleCov.start 'rails'
end
