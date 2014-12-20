class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.integer :creator_id
      t.datetime :date_from
      t.datetime :date_to
      t.integer :goal_id

      t.timestamps
    end
  end
end
