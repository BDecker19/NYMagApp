class AddRestaurantsUpdatedToRegion < ActiveRecord::Migration
  def change
    add_column :regions, :last_refresh, :datetime
  end
end
