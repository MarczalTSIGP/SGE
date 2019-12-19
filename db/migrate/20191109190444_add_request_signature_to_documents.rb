class AddRequestSignatureToDocuments < ActiveRecord::Migration[5.2]
  def change
    change_table :documents, bulk: true do |t|
      t.boolean :request_signature, default: false
    end
  end
end
