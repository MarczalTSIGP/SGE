class CreateClientsDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :clients_documents do |t|
      t.references :document, foreign_key: true
      t.references :client, foreign_key: true
      t.integer :hours
      t.timestamps
    end
    add_index(:clients_documents, [:document_id, :client_id], unique: true)
  end
end
