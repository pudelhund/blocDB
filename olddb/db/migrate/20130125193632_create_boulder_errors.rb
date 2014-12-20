class CreateBoulderErrors < ActiveRecord::Migration
  def change
    create_table :boulder_errors do |t|
      t.references :boulder
      t.references :user
      t.string :error
      t.integer :status

      t.timestamps
    end
    add_index :boulder_errors, :boulder_id
    add_index :boulder_errors, :user_id
  end
end
