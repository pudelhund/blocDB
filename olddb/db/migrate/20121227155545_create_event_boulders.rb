class CreateEventBoulders < ActiveRecord::Migration
  def change
    create_table :event_boulders do |t|
      t.integer :event_id
      t.integer :boulder_id

      t.timestamps
    end
  end
end
