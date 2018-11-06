class AddGenderToClients < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      CREATE TYPE client_kinds AS ENUM ('server', 'academic', 'external');
    SQL
    add_column :clients, :kind, :client_kinds
  end

  def down
    remove_column :clients, :kind
    execute <<-SQL
      DROP TYPE client_kinds;
    SQL
  end
end
