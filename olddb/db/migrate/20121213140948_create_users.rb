class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :external_key
      t.string :email
      t.string :password
      t.string :firstname
      t.string :lastname
      t.string :gender
      t.date :birthday
      t.text :signature
      t.boolean :is_visible
      t.datetime :last_login
      t.datetime :last_activity
      t.boolean :is_creator
      t.boolean :is_admin

      t.timestamps
    end
  end
end
