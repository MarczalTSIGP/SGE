class RenameClientsDocumentToClientDocument < ActiveRecord::Migration[5.2]
  def change
    rename_table :clients_documents, :client_documents
  end
end
