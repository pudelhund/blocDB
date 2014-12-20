class AddIconToColors < ActiveRecord::Migration
  def change
    add_column :colors, :icon, :string
  end
end
