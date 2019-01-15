class AddIndexToClients < ActiveRecord::Migration[5.2]
  def change
    add_index :clients, :kind
  end
end
