class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.string :name
      t.string :value
      t.integer :location_id

      t.timestamps
    end
    add_index :options, :name, :unique => true
  end
end
