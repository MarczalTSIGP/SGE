namespace :db do
	desc 'Erase and Fill database'
	task populate: :environment do
		populate_tasks = %w[departments users clients]

		puts 'DB seeds...'
		Rake::Task['db:seed'].invoke
		Rake::Task['db:clean'].invoke

		populate_tasks.each do |populate_task|
			Rake::Task["populate:#{populate_task}"].invoke
		end
	end
end
