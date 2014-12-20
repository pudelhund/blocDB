class BoulderRating < ActiveRecord::Migration
  def change
    create_table :boulder_ratings do |t|
      t.integer :boulder_id
      t.integer :user_id
      t.integer :rating

      t.timestamps
    end
    remove_column :boulder_ratings,:id
	execute "alter table boulder_ratings add primary key(boulder_id,user_id)"
  end
end
