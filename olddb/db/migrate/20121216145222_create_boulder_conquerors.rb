class CreateBoulderConquerors < ActiveRecord::Migration
  def change
    create_table :boulder_conquerors do |t|
      t.integer :boulder_id
      t.integer :user_id
      t.string :type
      t.integer :event_id

      t.timestamps
    end
  end
end
