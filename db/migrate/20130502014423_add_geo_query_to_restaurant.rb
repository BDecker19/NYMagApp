class AddGeoQueryToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :geo_query, :string
  end
end
