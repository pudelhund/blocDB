class CreateBoulderCreators < ActiveRecord::Migration
  def change
    create_table :boulder_creators do |t|
      t.integer :boulder_id
      t.integer :user_id

      t.timestamps
    end
  end
end
