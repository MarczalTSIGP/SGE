unless ENV['RAILS_ENV'] != 'test'
  require 'simplecov'
  require 'simplecov-console'
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
                                                                   SimpleCov::Formatter::Console,
                                                                   SimpleCov::Formatter::HTMLFormatter
                                                                 ])
  SimpleCov.start 'rails' do
    add_filter 'app/channels/application_cable'
    add_filter 'app/jobs/application_job.rb'
    add_filter 'app/mailers/application_mailer.rb'
    add_filter 'app/models/application_record.rb'
    add_filter 'app/controllers/application_controller.rb'
    add_filter 'app/controllers/participants/clients/passwords_controller.rb'
    add_filter 'app/validator'
  end
end
