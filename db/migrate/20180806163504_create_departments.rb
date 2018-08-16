class CreateDepartments < ActiveRecord::Migration[5.2]
  def change
    create_table :departments do |t|
      t.string :name
      t.text :description
      t.string :initials
      t.string :local
      t.string :phone
      t.string :email
      t.string :responsible

      t.timestamps
    end
  end
end
