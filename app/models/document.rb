class Document < ApplicationRecord
  enum kind: { certified: 'certified', declaration: 'declaration' }, _prefix: :kind

  has_many :users_documents, dependent: :destroy
  has_many :users, through: :users_documents, class_name: 'User'

  has_many :clients_documents, dependent: :destroy
  has_many :clients, through: :clients_documents, class_name: 'Client'

  accepts_nested_attributes_for :users_documents, :users, allow_destroy: true

  validates :description, presence: true
  validates :activity, presence: true
  validates :kind, inclusion: { in: Document.kinds.values }

  def self.search(search)
    if search
      where('unaccent(description) ILIKE unaccent(?) OR unaccent(activity) ILIKE unaccent(?) ',
            "%#{search}%", "%#{search}%").order('description ASC')
    else
      order(created_at: :DESC)
    end
  end

  def self.human_kinds
    hash = {}
    kinds.keys.each { |key| hash[I18n.t("enums.kinds.#{key}")] = key }
    hash
  end
end
