class Document < ApplicationRecord
  require 'csv'
  enum kind: { certified: 'certified', declaration: 'declaration' }, _prefix: :kind
  attr_accessor :participants


  has_and_belongs_to_many :clients
  has_many :users
  has_many :users_documents, dependent: :destroy
  has_many :users, through: :users_documents

  validates :description, presence: true
  validates :activity, presence: true
  validates :kind, inclusion: { in: Document.kinds.values }
  # validates :clients,

  def self.search(search)
    if search
      where('unaccent(description) ILIKE unaccent(?) OR unaccent(activity) ILIKE unaccent(?) ',
            "%#{search}%", "%#{search}%").order('description ASC')
    else
      order(created_at: :asc)
    end
  end

  def self.human_kinds
    hash = {}
    kinds.keys.each { |key| hash[I18n.t("enums.kinds.#{key}")] = key }
    hash
  end

  def self.csv_import(file, document_id)
    unless (file.nil?)
      ClientsDocument.where(document_id: document_id).destroy_all
      CSV.foreach(file.path, headers: true) do |row|
        document_hash = {}
        row.to_hash.each_pair do |key, value|
          document_hash.merge!({ key.downcase => value })
        end
        if (client_id = Client.find_by(cpf: document_hash['cpf']))
          document = ClientsDocument.new
          document.client_id = client_id.id
          document.hours = document_hash['horas']
          document.document_id = document_id
          document.save
        end
      end
    end
  end
end
