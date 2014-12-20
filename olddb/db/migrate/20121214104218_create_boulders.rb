class CreateBoulders < ActiveRecord::Migration
  def change
    create_table :boulders do |t|
      t.string :name
      t.text :description
      t.integer :level_intern
      t.integer :level_public
      t.integer :color_id
      t.integer :points
      t.integer :status
      t.datetime :remove_date
      t.integer :votes
      t.integer :rating
      t.integer :climbers
      t.datetime :manual_modified
      t.datetime :disable_date
      t.integer :wall_from
      t.integer :wall_to

      t.timestamps
    end
  end
end
