require './lib/populate/departments'

namespace :populate do
  desc 'Populate departments'

  task departments: :environment do
    puts 'Populating departments...'
    Populate::Departments.new.populate
  end
end
