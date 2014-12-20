class AddFlashedToRanking < ActiveRecord::Migration
  def change
    add_column :rankings, :flashed, :integer
  end
end
