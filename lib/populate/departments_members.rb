module Populate
  class DepartmentsMembers
    def initialize
      @users = User.activated
      @departments = Department.all
      @roles = Role.all
    end

    def populate
      insert_members
    end

    private

    def insert_members
      15.times do |i|
        add_member(@departments[i], @users[i].id, @roles.find_by(identifier: 'manager').id)
        add_member(@departments[i], @users[@users.length - 1].id,
                   @roles.find_by(identifier: 'member_department').id)
      end
    end

    def add_member(department, user_id, role_id)
      member = department.department_users.build(user_id: user_id,
                                                 role_id: role_id)
      member.save
    end
  end
end
