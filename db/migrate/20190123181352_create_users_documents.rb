class CreateUsersDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :users_documents do |t|
      t.references :document, foreign_key: true
      t.references :user, foreign_key: true
      t.boolean :subscription, default: false
      t.string :function
      t.timestamps
    end
    add_index(:users_documents, [:document_id, :user_id], unique: true)
  end
end
