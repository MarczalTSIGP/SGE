class CreateDocumentClients < ActiveRecord::Migration[5.2]
  def change
    create_table :document_clients do |t|
      t.belongs_to :document, index: true, foreign_key: true
      t.belongs_to :client, index: true, foreign_key: true
      t.json :information, null: false, default: {}
      t.string :cpf
      t.string :name
      t.timestamps
    end
  end
end
