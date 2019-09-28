require './lib/populate/departments_members'

namespace :populate do
  desc 'Populate departments members'

  task departments_members: :environment do
    puts 'Populating departments members...'
    Populate::DepartmentsMembers.new.populate
  end
end
