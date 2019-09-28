module Populate
  class DivisionsMembers
    def initialize
      @departments = Department.all
      @roles = Role.all
    end

    def populate
      insert_members
    end

    private

    def insert_members
      15.times do |i|
        users = @departments[i].users
        division = @departments[i].divisions
        add_member(division.first, users.first.id, @roles.find_by(identifier: 'responsible').id)
        add_member(division.first, users.last.id,
                   @roles.find_by(identifier: 'member_division').id)
      end
    end

    def add_member(division, user_id, role_id)
      member = division.division_users.create(user_id: user_id,
                                             role_id: role_id)
      member.save
    end
  end
end
