class Client < ApplicationRecord
  include PrettyCPF
  attr_writer :login

  enum kind: { server: 'server', external: 'external', academic: 'academic' }, _prefix: :kind
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, authentication_keys: [:login]

  validates :name, :cpf, presence: true
  validates :alternative_email, allow_blank: true, uniqueness: { case_sensitive: false }
  validates :cpf, uniqueness: { case_sensitive: false }
  validates :alternative_email, allow_blank: true, format: { with: Devise.email_regexp }
  validates :cpf, cpf: true
  validates :kind, inclusion: { in: Client.kinds.values }

  def login
    @login || cpf || email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions.to_h).where(['lower(cpf) = :value OR lower(email) = :value',
                                    { value: login.downcase }]).first
    elsif conditions.haskey?(:cpf) || conditions.haskey?(:email)
      where(conditions.to_h).first
    end
  end

  def self.human_kinds
    hash = {}
    kinds.keys.each { |key| hash[I18n.t("enums.type.#{key}")] = key }
    hash
  end
end
