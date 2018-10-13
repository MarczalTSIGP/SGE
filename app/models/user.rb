class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  VALID_USERNAME_REGEX = /\A[a-z0-9\-_]+\z/i
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  before_validation :register_username
  before_create :complete_email
  after_update :complete_email

  attr_writer :login

  devise :database_authenticatable, :rememberable, :trackable,
         :validatable, authentication_keys: [:login]


  validates :name, :cpf, :registration_number, presence: true
  validates :registration_number, :username, uniqueness: true
  validates :cpf, length: {is: 11}, uniqueness: true
  validates :username, presence: true, format: {with: VALID_USERNAME_REGEX}
  validates :alternative_email,   allow_blank:  true, format: {with: VALID_EMAIL_REGEX}
  validate :validate_cpf


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
    if search
      where("name LIKE ? OR email LIKE ? OR alternative_email LIKE ?",
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

  def validate_cpf
    array_cpf = self.cpf.to_s.split(//)
    unless (array_cpf[9] == (validation_calculation(array_cpf.take(9)).to_s)) and (array_cpf[10] == (validation_calculation(array_cpf.take(10)).to_s))
      errors.add(:cpf, I18n.t('errors.messages.invalid'))
    end
  end

  def validation_calculation(array_cpf)
    soma = 0
    multi = 0
    array_cpf.each_with_index do |digit, index|
      multi = digit.to_i * (array_cpf.length + 1 - index)
      soma += multi
    end
    result = soma * 10 % 11
    if result == 10
      return 0
    else
      return result
    end
  end

  def register_username
    unless (self.username.nil?)
      self.username = self.username.split('@').first
    end
  end

  def complete_email
    self.email = self.username + '@utfpr.edu.br'
    self.password = 123456
  end


end
