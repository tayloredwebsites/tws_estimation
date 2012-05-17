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

ActiveRecord::Schema.define(:version => 20120517124728) do

  create_table "assemblies", :force => true do |t|
    t.string   "description", :default => "",    :null => false
    t.integer  "sort_order",  :default => 0,     :null => false
    t.boolean  "required",    :default => false, :null => false
    t.boolean  "deactivated", :default => false, :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "assemblies", ["description"], :name => "index_assemblies_on_description", :unique => true

  create_table "assembly_components", :force => true do |t|
    t.integer  "assembly_id",                     :null => false
    t.integer  "component_id",                    :null => false
    t.string   "description",  :default => "",    :null => false
    t.boolean  "required",     :default => true,  :null => false
    t.boolean  "deactivated",  :default => false, :null => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

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

  create_table "components", :force => true do |t|
    t.integer  "component_type_id",                    :null => false
    t.string   "description",       :default => "",    :null => false
    t.integer  "default_id"
    t.boolean  "calc_only",         :default => false, :null => false
    t.boolean  "deactivated",       :default => false, :null => false
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  add_index "components", ["component_type_id", "description"], :name => "index_components_on_component_type_id_and_description", :unique => true

  create_table "defaults", :force => true do |t|
    t.string   "store",                                      :default => "",    :null => false
    t.string   "name",                                       :default => "",    :null => false
    t.decimal  "value",       :precision => 19, :scale => 4, :default => 0.0,   :null => false
    t.boolean  "deactivated",                                :default => false, :null => false
    t.datetime "created_at",                                                    :null => false
    t.datetime "updated_at",                                                    :null => false
  end

  create_table "estimate_assemblies", :force => true do |t|
    t.integer  "estimate_id",                    :null => false
    t.integer  "assembly_id",                    :null => false
    t.boolean  "selected",    :default => false, :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "estimate_assemblies", ["assembly_id"], :name => "index_estimate_assemblies_on_assembly_id"
  add_index "estimate_assemblies", ["estimate_id"], :name => "index_estimate_assemblies_on_estimate_id"

  create_table "estimates", :force => true do |t|
    t.string   "title",                              :null => false
    t.string   "customer_name",                      :null => false
    t.string   "customer_note",   :default => "",    :null => false
    t.integer  "sales_rep_id",                       :null => false
    t.integer  "job_type_id",                        :null => false
    t.integer  "state_id",                           :null => false
    t.boolean  "prevailing_wage", :default => false, :null => false
    t.string   "note",            :default => "",    :null => false
    t.boolean  "deactivated",     :default => false, :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "estimates", ["job_type_id"], :name => "index_estimates_on_job_type_id"
  add_index "estimates", ["sales_rep_id"], :name => "index_estimates_on_sales_rep_id"
  add_index "estimates", ["state_id"], :name => "index_estimates_on_state_id"

  create_table "job_types", :force => true do |t|
    t.string   "name",        :default => "",    :null => false
    t.string   "description", :default => "",    :null => false
    t.integer  "sort_order",  :default => 0,     :null => false
    t.boolean  "deactivated", :default => false, :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "sales_reps", :force => true do |t|
    t.integer  "user_id",                                                          :null => false
    t.decimal  "min_markup_pct", :precision => 18, :scale => 4
    t.decimal  "max_markup_pct", :precision => 18, :scale => 4
    t.boolean  "deactivated",                                   :default => false, :null => false
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
  end

  create_table "states", :force => true do |t|
    t.string   "code",       :default => "", :null => false
    t.string   "name",       :default => "", :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
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

  add_foreign_key "assembly_components", "assemblies", :name => "assembly_components_assembly_id_fk"
  add_foreign_key "assembly_components", "components", :name => "assembly_components_component_id_fk"

  add_foreign_key "components", "component_types", :name => "components_component_type_id_fk"
  add_foreign_key "components", "defaults", :name => "components_default_id_fk"

  add_foreign_key "estimate_assemblies", "assemblies", :name => "estimate_assemblies_assembly_id_fk"
  add_foreign_key "estimate_assemblies", "estimates", :name => "estimate_assemblies_estimate_id_fk"

  add_foreign_key "estimates", "job_types", :name => "estimates_job_type_id_fk"
  add_foreign_key "estimates", "sales_reps", :name => "estimates_sales_rep_id_fk"
  add_foreign_key "estimates", "states", :name => "estimates_state_id_fk"

  add_foreign_key "sales_reps", "users", :name => "sales_reps_user_id_fk"

end
