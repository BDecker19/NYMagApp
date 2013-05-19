class AddQueryCodeToRegion < ActiveRecord::Migration
  def change
    add_column :regions, :query_code, :string
  end
end
