class CreateShortUrls < ActiveRecord::Migration[7.1]
  def change
    create_table :short_urls do |t|
      t.references :url, null: false, foreign_key: true
      t.string :short_url, null: false, limit: 15
      t.timestamps
    end
    add_index :short_urls, :short_url, unique: true
  end
end
