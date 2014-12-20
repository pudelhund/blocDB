class LocationBasedRanking < ActiveRecord::Migration
  def change
    add_column :rankings, :location_id, :integer
	add_column :boulder_points_temp, :location_id, :integer
  end
end
