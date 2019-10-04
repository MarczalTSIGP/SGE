namespace :db do
	desc 'Erase and Fill database'
	task populate: :environment do
		populate_tasks = %w[users clients roles departments departments_members divisions divisions_members]

		puts 'DB seeds...'
		Rake::Task['db:clean'].invoke
		Rake::Task['db:seed'].invoke

		populate_tasks.each do |populate_task|
			Rake::Task["populate:#{populate_task}"].invoke
		end
	end
end
