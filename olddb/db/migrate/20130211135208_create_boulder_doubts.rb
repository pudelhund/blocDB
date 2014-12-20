class CreateBoulderDoubts < ActiveRecord::Migration
  def change
    create_table :boulder_doubts do |t|
      t.references :boulder
      t.references :user
      t.references :author
      t.string :description
      t.integer :status

      t.timestamps
    end
    add_index :boulder_doubts, :boulder_id
    add_index :boulder_doubts, :user_id
    add_index :boulder_doubts, :author_id
  end
end
