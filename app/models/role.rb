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

  def self.where_roles(id, department)
    manager = Role.find_by(identifier: 'manager')
    responsible = Role.find_by(identifier: 'responsible')
    if manager_present?(id, manager) && !department
      where.not(id: manager.id, department: department)
    elsif responsible_present?(id, responsible) && department
      where.not(id: responsible.id, department: department)
    else
      where(department: !department)
    end
  end

  class << self
    private

    def manager_present?(id, role)
      du = DepartmentUser.find_by(department_id: id, role_id: role.id)
      du.present?
    end

    def responsible_present?(id, role)
      du = DivisionUser.find_by(division_id: id, role_id: role.id)
      du.present?
    end
  end
end
