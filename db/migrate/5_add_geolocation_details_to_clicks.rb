# In db/migrate/5_add_geolocation_details_to_clicks.rb
class AddGeolocationDetailsToClicks < ActiveRecord::Migration[7.0]
  def change
    add_column :clicks, :country, :string
    add_column :clicks, :city, :string
    add_column :clicks, :latitude, :float
    add_column :clicks, :longitude, :float
  end
end