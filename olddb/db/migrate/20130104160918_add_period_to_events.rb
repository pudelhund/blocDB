class AddPeriodToEvents < ActiveRecord::Migration
  def change
    add_column :events, :period, :boolean
  end
end
