class CreateDivisions < ActiveRecord::Migration[5.2]
  def change
    create_table :divisions do |t|
      t.string :name
      t.string :description
      t.integer :department_id, references: [:departments, :id]
      t.timestamps
    end
  end
end
