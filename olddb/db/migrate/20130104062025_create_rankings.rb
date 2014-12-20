class CreateRankings < ActiveRecord::Migration
  def change
    create_table :rankings do |t|
      t.references :user
      t.integer :status
      t.integer :points
      t.integer :conquer_count

      t.timestamps
    end
    add_index :rankings, :user_id
  end
end
