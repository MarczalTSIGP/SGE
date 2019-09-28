class User < ApplicationRecord
  include PrettyCPF
  include LoginAuthentication

  scope :activated, -> { where(active: true) }

  also_login_by :username

  devise :database_authenticatable, :rememberable, :trackable,
         :validatable, authentication_keys: [:login]

  validates :name, :cpf, :registration_number, presence: true
  validates :registration_number, :username, :cpf, uniqueness: { case_sensitive: false }
  validates :alternative_email, allow_blank: true, format: { with: Devise.email_regexp }
  validates :cpf, cpf: true

  after_validation :username_errors_message

  has_many :department_users, dependent: :destroy
  has_many :departments, through: :department_users
  has_many :division_users, dependent: :destroy
  has_many :divisions, through: :division_users

  def username=(username)
    super
    self.email = (username + '@utfpr.edu.br')
  end

  def self.search(search)
    if search
      where('unaccent(name) ILIKE unaccent(?) OR email ILIKE ? OR alternative_email ILIKE ?',
            "%#{search}%", "%#{search}%", "%#{search}%").where(support: false).order('name ASC')
    else
      where(support: false).order('name ASC')
    end
  end

  def role_for_department(department)
    department_users.find_by(department: department).try(:role)
  end

  def role_for_division(division)
    division_users.find_by(division: division).try(:role)
  end

  def self.not_in(department)
    User.where.not(id: department.users)
  end

  private

  def password_required?
    false
  end

  def username_errors_message
    return if errors.messages[:email].nil?

    errors.messages[:username] = errors.messages[:email]
  end
end
