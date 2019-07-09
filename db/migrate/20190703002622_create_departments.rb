class CreateDepartments < ActiveRecord::Migration[5.2]
  def change
    create_table :departments do |t|
      t.string :name
      t.string :local
      t.string :phone
      t.string :initials
      t.string :email
      t.text :description

      t.timestamps
    end
  end
end
