class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles do |t|
      t.string :name
      t.string :flag, index: true

      t.timestamps
    end
  end
end
