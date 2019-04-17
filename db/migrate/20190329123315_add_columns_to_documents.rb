class AddColumnsToDocuments < ActiveRecord::Migration[5.2]
  def change
    add_column :documents, :title, :string
    add_column :documents, :request_signature, :boolean, default: false
  end
end
