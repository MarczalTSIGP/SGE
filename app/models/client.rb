class Client < ApplicationRecord
  include PrettyCPF
  include LoginAuthentication

  also_login_by :cpf

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, authentication_keys: [:login]

  enum kind: { server: 'server', external: 'external', academic: 'academic' }, _prefix: :kind
  def self.human_kinds
    hash = {}
    kinds.each_key { |key| hash[I18n.t("enums.kinds.#{key}")] = key }
    hash
  end

  validates :name, :cpf, :kind, presence: true
  validates :alternative_email, allow_blank: true,
                                format: { with: Devise.email_regexp }

  validates :cpf, cpf: true, uniqueness: { case_sensitive: false }
end
