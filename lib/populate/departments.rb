module Populate
  class Departments

    def populate
      create_departments
    end

    private

    def create_departments
      Faker::Config.locale = 'pt-BR'
      75.times do |i|
        phone = Faker::PhoneNumber.phone_number
        Department.create!(
          name: Faker::Name.name,
          email: Faker::Internet.unique.username,
          phone: phone.delete(' '),
          local: Faker::LordOfTheRings.location,
          description: Faker::Lorem.paragraph,
          initials: Faker::Address.unique.country_code_long
        )
      end
    end
  end
end
