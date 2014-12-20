class CreateWalls < ActiveRecord::Migration
  def change
    create_table :walls do |t|
      t.string :name
      t.text :description
      t.integer :location_id

      t.timestamps
    end
  end
end
