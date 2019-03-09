class Client < ApplicationRecord
  attr_writer :login

  include PrettyCPF
  include LoginAuthentication
  also_login_by :cpf

  enum kind: { server: 'server', external: 'external', academic: 'academic' }, _prefix: :kind

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, authentication_keys: [:login]

  has_many :clients_documents, dependent: :destroy
  has_many :documents, through: :clients_documents



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
    kinds.each_key { |key| hash[I18n.t("enums.type.#{key}")] = key }
    hash
  end

  def self.search(query)
    order(:name).where('name ilike ?', "#{query}%")
  end
end
