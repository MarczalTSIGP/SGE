module Admin::ClientsDocumentsHelper
  def field_invalid(value, client_document)
    value.blank? & !client_document.errors[:participant_hours_fields].blank? ? 'is-invalid' : ''
  end
end
