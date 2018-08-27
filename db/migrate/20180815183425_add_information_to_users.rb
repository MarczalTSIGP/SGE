class AddInformationToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :username, :string
    add_index :users, :username, unique: true
    add_column :users, :name, :string
    add_column :users, :registration_number, :integer
    add_index :users, :registration_number, unique: true
    add_column :users, :active, :boolean
    add_column :users, :cpf, :string
    add_index :users, :cpf, unique: true
  end
end
