class CreateDocumentUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :document_users do |t|
      t.references :document, foreign_key: true
      t.references :user, foreign_key: true
      t.string :function
      t.timestamps
    end
    add_index(:document_users, [:document_id, :user_id], unique: true)
  end
end
