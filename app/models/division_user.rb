class DivisionUser < ApplicationRecord
  belongs_to :division, optional: false
  belongs_to :user, optional: false
  belongs_to :role, optional: false

  validates :user_id, uniqueness: { scope: :division_id }
end
