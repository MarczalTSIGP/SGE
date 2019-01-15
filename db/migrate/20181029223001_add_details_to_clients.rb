class AddDetailsToClients < ActiveRecord::Migration[5.2]
  def change
    change_table :clients, bulk: true do |t|
      t.string :cpf
      t.string :name
      t.integer :ra
      t.string :alternative_email
    end
    add_index :clients, :cpf, unique: true
    add_index :clients, :ra, unique: true
  end
end
