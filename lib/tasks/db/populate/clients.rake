require './lib/populate/clients'

namespace :populate do
  desc 'Populate clients'

  task clients: :environment do
    puts 'Populating clients...'
    Populate::Clients.new.populate
  end
end
