namespace :db do
  desc 'Clean data'

  task clean: :environment do
    puts 'Cleaning data...'

    [User, Client, Role,
     DepartmentUser,
     Department, DivisionUser,
     Division].each(&:delete_all)

    User.where.not(email: 'admin@utfpr.edu.br').destroy_all
  end
end
