Capybara.register_driver :selenium do |app|
  options = Selenium::WebDriver::Chrome::Options.new(args: ['headless'])

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end
