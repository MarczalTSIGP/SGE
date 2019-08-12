require './lib/populate/members'

namespace :populate do
  desc 'Populate members'

  task members: :environment do
    puts 'Populating members...'
    Populate::Members.new.populate
  end
end
