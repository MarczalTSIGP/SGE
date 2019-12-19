class DocumentClient < ApplicationRecord
  include PrettyCPF
  belongs_to :document
  belongs_to :client

  validates :cpf, presence: true
  validates :cpf, cpf: true

  def self.search(search)
    if search
      where('unaccent(cpf) ILIKE unaccent(?)',
            "%#{search}%").order('cpf ASC')
    else
      order('cpf ASC')
    end
  end

  def self.import(file, id)
    document = Document.find(id)
    return if file.blank?

    CSV.foreach(file.path, headers: true) do |row|
      cpf = row[0].to_s
      information_fields = row.to_hash
      information_fields = information_fields.without('cpf')
      document.document_clients.create(document_id: document.id, cpf: cpf,
                                       information: information_fields,
                                       key_code: SecureRandom.urlsafe_base64(nil, false))
    end
  end
end
