namespace :db do
  desc 'Clean data'

  task clean: :environment do
    puts 'Cleaning data...'

    [Client].each(&:delete_all)

    User.where.not(email: 'admin@utfpr.edu.br').destroy_all
  end
end
