class DivisionUser < ApplicationRecord
  belongs_to :division, required: true
  belongs_to :user, required: true
  belongs_to :role, required: true
end
