class CreateDivisionUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :division_users do |t|
      t.belongs_to :division, index: true
      t.belongs_to :user, index: true
      t.belongs_to :role, index: true

      t.timestamps
    end
  end
end
