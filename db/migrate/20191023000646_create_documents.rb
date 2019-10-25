class CreateDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :documents do |t|
      t.string :title
      t.text :front
      t.text :back
      t.belongs_to :division, foreign_key: true

      t.timestamps
    end
  end
end
