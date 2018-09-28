class Department < ApplicationRecord
  validates :name, presence: true
  validates :local, presence: true
  validates :phone, presence: true, length: {minimum: 10, maximum: 13}
  validates :initials, presence: true, length: {minimum: 3, maximum: 8}, uniqueness: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX }

  has_many :department_users
  has_many :users, through: :department_users

  def initials=(s)
    write_attribute(:initials, s.to_s.upcase) # The to_s is in case you get nil/non-string
  end

  def add_member(member, role)
    department_users.create(user: member, role: Role.find_by(flag: role))
  end
end
