class User < ApplicationRecord
  include PrettyCPF

  attr_writer :login

  devise :database_authenticatable, :rememberable, :trackable,
         :validatable, authentication_keys: [:login]

  after_validation :username_errors_message
  before_create :set_default_password # we will use ldap not password! it is necessary until configure ldap

  validates :name, :cpf, :registration_number, presence: true
  validates :registration_number, :username, :cpf, uniqueness: { case_sensitive: false }
  validates :alternative_email, allow_blank:  true, format: {with: Devise.email_regexp}
  validates :cpf, cpf: :true

  def username=(username)
    super
    self.email=(username + '@utfpr.edu.br')
  end

  def login
    @login || self.username || self.email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value",
                                    {:value => login.downcase}]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  def self.search(search)
    printf("##############################################################")
    print(search)
    if search
          where("unaccent(name) ILIKE unaccent(?) OR email ILIKE ? OR alternative_email ILIKE ?",
            "%#{search}%", "%#{search}%", "%#{search}%").where(support: false).order('name ASC')
    else
      where(support: false).order('name ASC')
    end
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
    self.password = 123456
  end

  def username_errors_message
    unless self.errors.messages[:email].nil?
      self.errors.messages[:username] = self.errors.messages[:email];
    end
  end

end
