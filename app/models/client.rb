class Client < ApplicationRecord
  include PrettyCPF
  attr_writer :login

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, authentication_keys: [:login]

  validates :name, :cpf, :ra, presence: true
  validates :cpf, :ra, uniqueness: {case_sensitive: false}
  validates :cpf, cpf: true

  def login
    @login || ra || email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(name) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:ra) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end
end
