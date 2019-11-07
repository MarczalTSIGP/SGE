class AddVariablesToDocuments < ActiveRecord::Migration[5.2]
  def change
    add_column :documents, :variables, :json, null: false, default: {}
  end
end
