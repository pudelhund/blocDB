class RemoveGoalIdFromUsers < ActiveRecord::Migration
  def up
	remove_column :events, :goal_id
  end

  def down
  end
end
