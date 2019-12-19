module ApplicationHelper
  def full_title(page_title = '', base_title = 'SGE')
    if page_title.empty?
      base_title
    else
      page_title + ' | ' + base_title
    end
  end

  def bootstrap_class_for(flash_type)
    { success: 'alert-success', error: 'alert-danger', alert: 'alert-warning',
      notice: 'alert-info' }[flash_type.to_sym] || flash_type.to_s
  end

  def sub_hash_fields_document(document, column, cpf)
    d = document.send(column)
    cpf = document.document_clients.find_by(cpf: cpf).cpf
    doc_client = informatio(document, cpf)
    var = ActiveSupport::JSON.decode(document.variables)
    d = d.sub('{cpf}', cpf)
    var.each do |k, _v|
      d = d.sub('{' + k + '}', doc_client[k])
    end
    d
  end

  private

  def informatio(document, cpf)
    document.document_clients.find_by(cpf: cpf).information
  end
end
