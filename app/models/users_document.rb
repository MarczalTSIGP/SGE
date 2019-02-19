class UsersDocument < ApplicationRecord
  belongs_to :document
  belongs_to :user

  accepts_nested_attributes_for :user

  validates :user, uniqueness: { scope: :document }
  validates :function, :user_id, presence: true
end
