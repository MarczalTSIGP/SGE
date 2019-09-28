require './lib/populate/divisions_members'

namespace :populate do
  desc 'Populate divisions members'

  task divisions_members: :environment do
    puts 'Populating divisions members...'
    Populate::DivisionsMembers.new.populate
  end
end
