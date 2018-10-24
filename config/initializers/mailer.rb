Rails.application.config.action_mailer.default_url_options = { host: ENV['mailer.host'],
                                                               port: ENV['mailer.port'] }
