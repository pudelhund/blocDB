class AddBannerToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :banner, :string
  end
end
