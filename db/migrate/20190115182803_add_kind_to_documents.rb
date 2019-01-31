class AddKindToDocuments < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      CREATE TYPE document_kinds AS ENUM ('certified', 'declaration');
    SQL
    add_column :documents, :kind, :document_kinds
  end

  def down
    remove_column :documents, :kind
    execute <<-SQL
      DROP TYPE document_kinds;
    SQL
  end
end
