class DepartmentUser < ApplicationRecord
  belongs_to :department, required: true
  belongs_to :user, required: true
  belongs_to :role, required: true

  validates :user_id, uniqueness: { scope: :department_id }

  def destroy_custom(member, divisions)
    div = DivisionUser.find_by(user_id: member, division_id: divisions.ids)
    div.nil?
  end
end
