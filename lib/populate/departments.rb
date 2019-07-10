module Populate
  class Departments

    def populate
      create_departments
      insert_members
    end

    private

    def create_departments
      Faker::Config.locale = 'pt-BR'
      15.times do
        Department.create!(
            name: Faker::Name.name,
            email: Faker::Internet.unique.username,
            phone: Faker::PhoneNumber.phone_number,
            local: Faker::LordOfTheRings.location,
            description: Faker::Lorem.paragraph,
            initials: Faker::Address.unique.country_code_long
        )
      end

      def insert_members
        users = User.where(active: true)

        15.times do |i|
          department = Department.find(i + 1)
          add_member(department, users[i].id, 1)
          add_member(department, users[users.length - 1].id, 2)
        end
      end

      def add_member(department, user_id, role_id)
        member = department.department_users.build(user_id: user_id,
                                                   role_id: role_id)
        member.save
      end
    end
  end
end
