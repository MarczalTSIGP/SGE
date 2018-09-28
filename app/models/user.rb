class User < ApplicationRecord
  has_many :department_users
  has_many :departments, through: :department_users

  def role_by(department)
    department_users.find_by(department: department).try(:role)
  end

  def self.not_in(department)
    User.where.not(id: department.users)
  end
end
