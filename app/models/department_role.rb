class DepartmentRole < ApplicationRecord
  belongs_to :department
  belongs_to :user
  belongs_to :role

  def self.users(department)
    where(department: department)
  end
end
