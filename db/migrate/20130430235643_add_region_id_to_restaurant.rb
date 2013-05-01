class AddRegionIdToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :region_id, :integer
  end
end
