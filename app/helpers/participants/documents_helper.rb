module Participants::DocumentsHelper
  def sub_hash_fields(document, column, client)
    d = document.send(column)
    cpf = to_cpf(document, client)
    doc_client = to_information(document, client)
    var = ActiveSupport::JSON.decode(document.variables)
    d = d.sub('{cpf}', cpf)
    var.each do |k, _v|
      d = d.sub('{' + k + '}', doc_client[k])
    end
    d
  end

  private

  def to_cpf(document, client)
    document.document_clients.find_by(cpf: client.cpf).cpf
  end

  def to_information(document, client)
    document.document_clients.find_by(cpf: client.cpf).information
  end
end
