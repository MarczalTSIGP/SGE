class Client < ApplicationRecord
  include PrettyCPF
  attr_writer :login
  include LoginAuthentication
  arguable include: [:cpf]
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

  def self.human_kinds
    hash = {}
    kinds.keys.each { |key| hash[I18n.t("enums.type.#{key}")] = key }
    hash
  end
end
