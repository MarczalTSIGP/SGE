class DocumentClient < ApplicationRecord
  include PrettyCPF
  belongs_to :document #, required: true
  belongs_to :client #, required: true

  # validates :client_id, uniqueness: { scope: :document_id }
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
                                       information: information_fields)

    end
  end
end


