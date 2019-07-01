Capybara.register_driver :firefox_headless do |app|
  options = ::Selenium::WebDriver::Firefox::Options.new
  options.args << '--headless'

  Capybara::Selenium::Driver.new(app, browser: :firefox, options: options)
end

if ENV['browser.headless'].eql?('true')
  RSpec.configure do |config|
    config.before(:each, type: :system) do
      driven_by :firefox_headless
    end
  end

  Capybara.javascript_driver = :firefox_headless
end
