require './lib/populate/roles'

namespace :populate do
  desc 'Populate roles'

  task roles: :environment do
    puts 'Populating roles...'
    Populate::Roles.new.populate
  end
end
