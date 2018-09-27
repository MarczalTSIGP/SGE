class AddAlternativeEmailToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :alternative_email, :string
  end
end
