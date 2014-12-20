class ChangeIndexOfOptions < ActiveRecord::Migration
  def change
  	remove_index :options, :name
  	add_index :options, [:name, :location_id], :unique => true
  end
end
