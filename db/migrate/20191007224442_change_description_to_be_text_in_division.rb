class ChangeDescriptionToBeTextInDivision < ActiveRecord::Migration[5.2]
  def change
    change_column :divisions, :description, :text
  end
end
