class Department < ApplicationRecord
  validates :name, presence: true
  validates :local, presence: true
  validates :phone, presence: true, length: {minimum: 10, maximum: 11}
  validates :initials, presence: true, length: {minimum: 3, maximum: 8}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :department_email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX }

  def initials=(s)
    write_attribute(:initials, s.to_s.upcase) # The to_s is in case you get nil/non-string
  end

end
