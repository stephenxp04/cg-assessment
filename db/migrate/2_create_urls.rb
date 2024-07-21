class CreateUrls < ActiveRecord::Migration[7.1]
  def change
    create_table :urls do |t|
      t.string :target_url
      t.string :title
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
