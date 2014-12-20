class AddImageToWalls < ActiveRecord::Migration
  def change
    add_column :walls, :image, :string
  end
end
