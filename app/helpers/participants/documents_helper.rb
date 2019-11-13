module Participants::DocumentsHelper
  def sub_hash_fields(document, column, client)
    d = document.send(column)
    cpf = document.document_clients.find_by(cpf: client.cpf).cpf
    doc_client = document.document_clients.find_by(cpf: client.cpf).information
    var = ActiveSupport::JSON.decode(document.variables)
    d = d.sub('{cpf}', cpf)
    var.each do |k, v|
      d = d.sub('{' + k + '}', doc_client[k])
    end
    d
  end
end