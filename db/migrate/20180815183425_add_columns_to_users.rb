class AddColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :username, :string
    add_column :users, :name, :string
    add_column :users, :active, :boolean, default: true
    add_column :users, :registration_number, :integer
    add_column :users, :cpf, :string
    add_column :users, :admin, :boolean, default: false
    add_column :users, :support, :boolean, default: false
    add_column :users, :alternative_email, :string

    add_index :users, :cpf, unique: true
    add_index :users, :username, unique: true
    add_index :users, :registration_number, unique: true

  end
end
