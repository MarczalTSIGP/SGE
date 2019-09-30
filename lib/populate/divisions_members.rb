module Populate
  class DivisionsMembers
    def initialize
      @divisions = Division.all
      @roles = Role.where(identifier: %w[responsible member_division])
    end

    def populate
      insert_members
    end

    private

    def insert_members
      15.times do |i|
        users = @divisions[i].department.users
        DivisionUser.create!(
          division_id: @divisions[i].id,
          user_id: users[0].id,
          role_id: @roles[0].id
        )
      end
    end
  end
end
