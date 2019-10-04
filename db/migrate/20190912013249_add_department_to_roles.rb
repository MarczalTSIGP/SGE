class AddDepartmentToRoles < ActiveRecord::Migration[5.2]
  def change
    add_column :roles, :department, :boolean, default: false
  end
end
