module Populate
  class Divisions
    def populate
      create_divisions
    end

    private

    def create_divisions
      @dept = Department.all
      15.times do |i|
        @dept[i].divisions.create!(
          name: Faker::Job.field,
          description: Faker::Lorem.paragraph
        )
      end
    end
  end
end
