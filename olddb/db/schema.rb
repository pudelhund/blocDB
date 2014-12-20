# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140506181749) do

  create_table "boulder_conquerors", :force => true do |t|
    t.integer  "boulder_id"
    t.integer  "user_id"
    t.string   "type"
    t.integer  "event_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "boulder_conquerors", ["boulder_id", "user_id", "event_id"], :name => "boulder_conquerors_identity", :unique => true

  create_table "boulder_creators", :force => true do |t|
    t.integer "boulder_id"
    t.integer "user_id"
  end

  add_index "boulder_creators", ["boulder_id", "user_id"], :name => "boulder_creators_identity", :unique => true

  create_table "boulder_doubts", :force => true do |t|
    t.integer  "boulder_id"
    t.integer  "user_id"
    t.integer  "author_id"
    t.string   "description"
    t.integer  "status"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "boulder_doubts", ["author_id"], :name => "index_boulder_doubts_on_author_id"
  add_index "boulder_doubts", ["boulder_id"], :name => "index_boulder_doubts_on_boulder_id"
  add_index "boulder_doubts", ["user_id"], :name => "index_boulder_doubts_on_user_id"

  create_table "boulder_errors", :force => true do |t|
    t.integer  "boulder_id"
    t.integer  "user_id"
    t.string   "error"
    t.integer  "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "boulder_errors", ["boulder_id"], :name => "index_boulder_errors_on_boulder_id"
  add_index "boulder_errors", ["user_id"], :name => "index_boulder_errors_on_user_id"

  create_table "boulder_points_temp", :id => false, :force => true do |t|
    t.integer "boulder_id"
    t.integer "points"
    t.integer "status"
    t.integer "event_id"
    t.integer "location_id"
  end

  create_table "boulder_ratings", :id => false, :force => true do |t|
    t.integer  "boulder_id",                               :null => false
    t.integer  "user_id",                                  :null => false
    t.decimal  "rating",     :precision => 2, :scale => 1
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  create_table "boulders", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "level_intern"
    t.integer  "level_public"
    t.integer  "color_id"
    t.integer  "points"
    t.integer  "status"
    t.datetime "remove_date"
    t.integer  "votes"
    t.decimal  "rating",          :precision => 2, :scale => 1
    t.integer  "climbers"
    t.datetime "manual_modified"
    t.datetime "disable_date"
    t.integer  "wall_from"
    t.integer  "wall_to"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at"
    t.integer  "rating_count"
  end

  create_table "colors", :force => true do |t|
    t.string   "name"
    t.string   "shortcut"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "icon"
  end

  create_table "comments", :force => true do |t|
    t.integer  "author_id"
    t.text     "text"
    t.integer  "boulder_id"
    t.integer  "vote"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "event_boulders", :force => true do |t|
    t.integer  "event_id"
    t.integer  "boulder_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "event_boulders", ["event_id", "boulder_id"], :name => "event_boulders_identity", :unique => true

  create_table "event_participants", :force => true do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "event_participants", ["event_id", "user_id"], :name => "event_participants_identity", :unique => true

  create_table "events", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "creator_id"
    t.datetime "date_from"
    t.datetime "date_to"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.boolean  "period"
    t.string   "goal"
    t.string   "logo"
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.text     "address"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "banner"
    t.string   "logo"
  end

  create_table "options", :force => true do |t|
    t.string   "name"
    t.string   "value"
    t.integer  "location_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "options", ["name", "location_id"], :name => "index_options_on_name_and_location_id", :unique => true

  create_table "rankings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "status"
    t.integer  "points"
    t.integer  "conquer_count"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "event_id"
    t.integer  "flashed"
    t.string   "gender"
    t.integer  "location_id"
  end

  add_index "rankings", ["user_id"], :name => "index_rankings_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "external_key"
    t.string   "email"
    t.string   "password"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "gender"
    t.date     "birthday"
    t.text     "signature"
    t.boolean  "is_visible"
    t.datetime "last_login"
    t.datetime "last_activity"
    t.boolean  "is_creator"
    t.boolean  "is_admin"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.integer  "group_id"
    t.integer  "is_participant"
    t.string   "avatar"
    t.decimal  "arm_span"
    t.decimal  "height"
    t.integer  "last_visited_location_id"
  end

  create_table "walls", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
  end

end
