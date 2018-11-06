class AddColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
    change_table :users, bulk: true do |t|
      t.column :username, :string
      t.column :name, :string
      t.column :active, :boolean, default: true
      t.column :registration_number, :integer
      t.column :cpf, :string
      t.column :admin, :boolean, default: false
      t.column :support, :boolean, default: false
      t.column :alternative_email, :string
    end

    add_index :users, :cpf, unique: true
    add_index :users, :username, unique: true
    add_index :users, :registration_number, unique: true
  end
end
