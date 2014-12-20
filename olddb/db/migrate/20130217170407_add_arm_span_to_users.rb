class AddArmSpanToUsers < ActiveRecord::Migration
  def change
    add_column :users, :arm_span, :decimal
  end
end
