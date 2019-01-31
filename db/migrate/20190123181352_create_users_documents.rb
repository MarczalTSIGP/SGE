class CreateUsersDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :users_documents do |t|
      t.references :document, foreign_key: true
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
