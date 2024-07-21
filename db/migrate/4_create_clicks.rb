class CreateClicks < ActiveRecord::Migration[7.1]
  def change
    create_table :clicks do |t|
      t.references :short_url, null: false, foreign_key: true
      t.string :geolocation
      t.datetime :clicked_at
      t.timestamps
    end
  end
end
