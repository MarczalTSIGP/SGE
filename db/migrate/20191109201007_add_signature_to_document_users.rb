class AddSignatureToDocumentUsers < ActiveRecord::Migration[5.2]
  def change
    change_table :document_users, bulk: true do |t|
      t.boolean :subscription, default: false
      t.datetime :signature_datetime
    end
  end
end
