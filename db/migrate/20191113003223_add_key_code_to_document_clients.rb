class AddKeyCodeToDocumentClients < ActiveRecord::Migration[5.2]
  def change
    change_table :document_clients, bulk: true do |t|
      t.string :key_code
    end
    add_index :document_clients, :key_code, unique: true
  end
end
