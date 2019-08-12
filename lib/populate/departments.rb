module Populate
  class Departments
    def populate
      create_departments
    end

    private

    def create_departments
      Faker::Config.locale = 'pt-BR'
      15.times do
        Department.create!(
          name: Faker::Name.name,
          email: Faker::Internet.unique.username(nil, %w[- _]),
          phone: Faker::PhoneNumber.phone_number,
          local: Faker::LordOfTheRings.location,
          description: Faker::Lorem.paragraph,
          initials: Faker::Address.unique.country_code_long
        )
      end
    end
  end
end
