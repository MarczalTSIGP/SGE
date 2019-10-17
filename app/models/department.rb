class Department < ApplicationRecord
  attr_accessor :email_name

  validates :name, presence: true
  validates :local, presence: true
  validates :phone, presence: true, length: { minimum: 10, maximum: 14 }
  validates :initials, presence: true, length: { minimum: 3, maximum: 8 }, uniqueness: true
  VALID_EMAIL_REGEX = /\A[A-Za-z0-9]+(?:[_-][A-Za-z0-9]+)*$\Z/
  validates :email,
            presence: true,
            uniqueness: true,
            length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX }
  has_many :divisions,
           foreign_key: 'department_id',
           dependent: :destroy,
           inverse_of: :department
  has_many :department_users, dependent: :destroy
  has_many :departments, through: :department_users
  has_many :users, through: :department_users
  has_many :roles, through: :department_users

  def self.search(search)
    if search
      where('unaccent(name) ILIKE unaccent(?) OR initials ILIKE unaccent(?)',
            "%#{search}%", "%#{search}%").order('name ASC')
    else
      order('name ASC')
    end
  end

  def email_domain
    "#{email}@utfpr.edu.br"
  end

  def name_with_initials
    "#{name} - #{initials}"
  end

  def initials=(initials)
    self[:initials] = initials.to_s.upcase # The to_s is in case you get nil/non-string
  end

  def self.manager(user)
    joins(:department_users).where(department_users: { role_id: Role.find_by(identifier: 'manager'),
                                                       user_id: user })
  end
end
