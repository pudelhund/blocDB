class AddLogoToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :logo, :string
  end
end
