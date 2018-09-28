class DepartmentUser < ApplicationRecord

  belongs_to :department, required: true
  belongs_to :user, required: true
  belongs_to :role, required: true

  validates :department_id, uniqueness: {scope: [:user_id, :role_id]}
end
