class Department < ApplicationRecord
  validates :name, presence: true
  validates :local, presence: true
  validates :phone, presence: true, length: { minimum: 10, maximum: 14 }
  validates :initials, presence: true, length: { minimum: 3, maximum: 8 }, uniqueness: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,
            presence: true,
            uniqueness: true,
            length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX }

  after_validation :email_errors_message

  has_many :department_users, dependent: :destroy
  has_many :users, through: :department_users

  def self.search(search)
    if search
      where('unaccent(name) ILIKE unaccent(?) OR initials ILIKE ? OR name ILIKE ?',
            "%#{search}%", "%#{search}%", "%#{search}%").order('name ASC')
    else
      order('name ASC')
    end
  end

  def email=(email)
    self[:email] = email << '@utfpr.edu.br'
  end

  def initials=(initials)
    self[:initials] = initials.to_s.upcase # The to_s is in case you get nil/non-string
  end

  def add_member(member, role)
    department_users.create(user: member, role: Role.find_by(flag: role))
  end

  def remove_member(member, role)
    department_users.destroy(user: member, role: Role.find_by(flag: role))
  end

  def remove_domain_email
    # write_attribute(:email,
    self[:email] = email.remove('@utfpr.edu.br')
  end

  private

  def email_errors_message
    return if errors.messages[:email].blank?

    remove_domain_email
  end
end
