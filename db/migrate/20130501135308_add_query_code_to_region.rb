class AddQueryCodeToRegion < ActiveRecord::Migration
  def change
    add_column :regions, :query_code, :integer
  end
end
