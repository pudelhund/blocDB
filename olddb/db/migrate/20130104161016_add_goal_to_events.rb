class AddGoalToEvents < ActiveRecord::Migration
  def change
    add_column :events, :goal, :string
  end
end
