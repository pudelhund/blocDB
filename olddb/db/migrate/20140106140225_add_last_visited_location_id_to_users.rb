class AddLastVisitedLocationIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_visited_location_id, :integer
  end
end
