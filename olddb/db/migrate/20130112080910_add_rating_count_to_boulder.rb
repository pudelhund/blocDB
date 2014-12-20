class AddRatingCountToBoulder < ActiveRecord::Migration
  def change
    add_column :boulders, :rating_count, :integer
  end
end
