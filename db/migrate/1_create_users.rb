class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :cookie, null: false
      t.timestamps
    end
    add_index :users, :cookie, unique: true
  end
end
