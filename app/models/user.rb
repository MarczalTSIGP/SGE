class User < ApplicationRecord
  attr_writer :login

  include PrettyCPF
  include LoginAuthentication
  also_login_by :username

  has_many :users_documents, dependent: :destroy
  has_many :documents, through: :users_documents

  devise :database_authenticatable, :rememberable, :trackable,
         :validatable, authentication_keys: [:login]

  after_validation :username_errors_message
  before_create :set_default_password # we will use ldap not password! this is necessary until that

  validates :name, :cpf, :registration_number, presence: true
  validates :registration_number, :username, :cpf, uniqueness: { case_sensitive: false }
  validates :alternative_email, allow_blank: true, format: { with: Devise.email_regexp }
  validates :cpf, cpf: true

  def username=(username)
    super
    self.email = (username + '@utfpr.edu.br')
  end

  def login
    @login || username || email
  end

  def self.search(search)
    if search
      where('unaccent(name) ILIKE unaccent(?) OR email ILIKE ? OR alternative_email ILIKE ?',
            "%#{search}%", "%#{search}%", "%#{search}%").where(support: false).order('name ASC')
    else
      where(support: false).order('name ASC')
    end
  end

  def self.signature(user)
    user.users_documents.map { |d| d.subscription }.count(false) > 0
  end
  private

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def password_required?
    false
  end

  def set_default_password
    self.password = '123456'
  end

  def username_errors_message
    return if errors.messages[:email].nil?

    errors.messages[:username] = errors.messages[:email]
  end
end
