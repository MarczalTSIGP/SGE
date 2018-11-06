class AddDetailsToClients < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :cpf, :string
    add_column :clients, :name, :string
    add_column :clients, :ra, :integer
    add_column :clients, :alternative_email, :string
    add_column :clients, :active, :boolean, default: true

    add_index :clients, :cpf, unique: true
    add_index :clients, :ra, unique: true
  end
end
