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

ActiveRecord::Schema.define(:version => 20140118101220) do

  create_table "alerts", :force => true do |t|
    t.string   "alert_type"
    t.integer  "installation_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "note",            :limit => 1000
  end

  create_table "conversations", :force => true do |t|
    t.string   "external_message_id"
    t.text     "message_prefix"
    t.text     "responds_via"
    t.integer  "installation_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "display_as"
  end

  create_table "events", :force => true do |t|
    t.string   "event_type"
    t.integer  "installation_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "note",            :limit => 1000
  end

  create_table "installations", :force => true do |t|
    t.string   "name"
    t.string   "phone"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.string   "designation"
    t.datetime "next_investigation_time"
    t.integer  "start_hour_of_concern"
    t.integer  "end_hour_of_concern"
    t.integer  "photo_refreshes_per_day"
    t.integer  "interrupt_duration"
    t.integer  "medication_reminder"
    t.integer  "medication_reminder_two"
    t.integer  "medication_reminder_three"
  end

  add_index "installations", ["designation"], :name => "index_installations_on_contact_id", :unique => true

  create_table "messages", :force => true do |t|
    t.integer  "installation_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.string   "image_text",               :limit => 1000
    t.datetime "last_display_in_carousel"
    t.boolean  "interrupt"
    t.string   "message_type"
    t.integer  "conversation_id"
  end

  create_table "usage_events", :force => true do |t|
    t.datetime "time"
    t.string   "usage_event_type"
    t.integer  "installation_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

end
