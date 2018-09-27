class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  before_validation :register_username
  before_create :complete_email

  attr_writer :login

  devise :database_authenticatable, :rememberable, :trackable,
         :validatable, authentication_keys: [:login]


  validates :name, :username, :cpf, :registration_number, presence: true
  validates :registration_number, uniqueness: true
  validates :cpf, length: {is: 11}, uniqueness: true
  validate :validate_cpf


  def login
    @login || self.username || self.email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", {:value => login.downcase}]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end


  def email_required?
    false
  end

  def email_changed?
    false
  end

  def password_required?
    false
  end

  private

  def validate_cpf
    array_cpf = self.cpf.to_s.split(//)
    unless (array_cpf[9] == (validation_calculation(array_cpf.take(9)).to_s)) and (array_cpf[10] == (validation_calculation(array_cpf.take(10)).to_s))
      errors.add(:cpf, "inválido")
    end
  end


  def self.search(search)
    where("name LIKE ? or email LIKE ? or alternative_email LIKE ?", "%#{search}%", "%#{search}%", "%#{search}%")
  end

  def validation_calculation(array_cpf)
    soma = 0
    multi = 0
    array_cpf.each_with_index do |digit, index|
      multi = digit.to_i * (array_cpf.length + 1 - index)
      soma += multi
    end
    return soma * 10 % 11
  end


  def register_username
    self.username = self.username.split('@').first
  end

  def complete_email
    self.email = self.username + '@utfpr.edu.br'
    self.password = 123456
  end


end
