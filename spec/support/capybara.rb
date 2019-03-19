# Capybara.register_driver :selenium do |app|
#   options = Selenium::WebDriver::Chrome::Options.new(args: ['headless'])
#
#   Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
# end
Capybara.register_driver :firefox_headless do |app|
  options = ::Selenium::WebDriver::Firefox::Options.new
  # options.args << '--headless'

  Capybara::Selenium::Driver.new(app, browser: :firefox, options: options)
end

Capybara.javascript_driver = :firefox_headless