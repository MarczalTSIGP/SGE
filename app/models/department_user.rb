class DepartmentUser < ApplicationRecord
  belongs_to :department, optional: false
  belongs_to :user, optional: false
  belongs_to :role, optional: false

  validates :user_id, uniqueness: { scope: :department_id }

  def destroy_custom(member, divisions)
    div = DivisionUser.find_by(user_id: member, division_id: divisions.ids)
    div.nil?
  end
end
