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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171016221006) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "logs", force: :cascade do |t|
    t.integer "message_id"
    t.integer "user_id"
    t.integer "flow_id"
    t.integer "intent_id"
    t.text "raw_message"
    t.boolean "has_attachment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "responses", id: false, force: :cascade do |t|
    t.integer "response_id"
    t.integer "stage_id"
    t.text "response_content"
    t.integer "step_id"
  end

end
