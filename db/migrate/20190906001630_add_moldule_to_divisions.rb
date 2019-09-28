class AddMolduleToDivisions < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      CREATE TYPE division_modules AS ENUM ('event', 'certified');
    SQL
    add_column :divisions, :kind, :division_modules
  end

  def down
    remove_column :divisions, :kind
    execute <<-SQL
      DROP TYPE division_modules;
    SQL
  end
end
