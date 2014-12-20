class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :author_id
      t.text :text
      t.integer :boulder_id
      t.integer :vote

      t.timestamps
    end
  end
end
