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

ActiveRecord::Schema.define(:version => 20120310161816) do

  create_table "component_types", :force => true do |t|
    t.string   "description", :default => "",    :null => false
    t.integer  "sort_order",  :default => 0,     :null => false
    t.boolean  "has_costs",   :default => true,  :null => false
    t.boolean  "has_hours",   :default => false, :null => false
    t.boolean  "has_vendor",  :default => false, :null => false
    t.boolean  "has_misc",    :default => false, :null => false
    t.boolean  "no_entry",    :default => false, :null => false
    t.boolean  "deactivated", :default => false, :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "component_types", ["description"], :name => "index_component_types_on_description", :unique => true

  create_table "defaults", :force => true do |t|
    t.string   "store",                                      :default => "",    :null => false
    t.string   "name",                                       :default => "",    :null => false
    t.decimal  "value",       :precision => 19, :scale => 4, :default => 0.0,   :null => false
    t.boolean  "deactivated",                                :default => false, :null => false
    t.datetime "created_at",                                                    :null => false
    t.datetime "updated_at",                                                    :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "roles"
    t.string   "username"
    t.string   "encrypted_password"
    t.string   "password_salt"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.boolean  "deactivated"
  end

end
