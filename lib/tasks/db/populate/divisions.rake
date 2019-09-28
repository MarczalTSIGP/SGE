require './lib/populate/divisions'

namespace :populate do
  desc 'Populate divisions'

  task divisions: :environment do
    puts 'Populating divisions...'
    Populate::Divisions.new.populate
  end
end
