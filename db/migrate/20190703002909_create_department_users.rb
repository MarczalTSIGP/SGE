class CreateDepartmentUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :department_users do |t|
      t.belongs_to :department, index: true
      t.belongs_to :user, index: true
      t.belongs_to :role, index: true

      t.timestamps
    end
  end
end
