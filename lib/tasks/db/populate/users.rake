require './lib/populate/users'

namespace :populate do
  desc 'Populate users'

  task users: :environment do
    puts 'Populating users...'
    Populate::Users.new.populate
  end
end
