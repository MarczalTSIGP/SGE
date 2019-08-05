class Role < ApplicationRecord
  has_many :department_users, dependent: :destroy
  has_many :departments, through: :department_users
  # def self.manager
  #   find_by(:manager)
  # end
  #
  # def self.event_coordinator
  #   find_by(:event_coordinator)
  # end
  #
  # def self.module_coordinator
  #   find_by(:module_coordinator)
  # end

  def self.where_roles(id)
    # role = Role.find_by(identifier: 'manager')
    role = Role.first
    du = DepartmentUser.find_by(department_id: id, role_id: role.id)
    if du.present?
      where.not(id: role.id)
    else
      all
    end
  end
end
