class AddSupportToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :support, :boolean, default: false
  end
end
