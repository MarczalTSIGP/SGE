class CreateDepartmentRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :department_roles do |t|
      t.references :department, foreign_key: true
      t.references :user, foreign_key: true
      t.references :role, foreign_key: true

      t.timestamps
    end
  end
end
