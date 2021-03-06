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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160423185649) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "academic_years", force: true do |t|
    t.integer  "year",                       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published",  default: false, null: false
  end

  add_index "academic_years", ["year"], name: "index_academic_years_on_year", unique: true, using: :btree

  create_table "bids", force: true do |t|
    t.integer  "student_id"
    t.integer  "course_id"
    t.integer  "preference"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quarter_id"
  end

  add_index "bids", ["course_id"], name: "index_bids_on_course_id", using: :btree
  add_index "bids", ["quarter_id"], name: "index_bids_on_quarter_id", using: :btree
  add_index "bids", ["student_id"], name: "index_bids_on_student_id", using: :btree

  create_table "courses", force: true do |t|
    t.string   "title"
    t.integer  "instructor_id"
    t.text     "syllabus"
    t.integer  "number"
    t.text     "prerequisites"
    t.text     "time"
    t.text     "location"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quarter_id"
    t.boolean  "draft",                default: false, null: false
    t.string   "website"
    t.string   "satisfies"
    t.boolean  "published",            default: false, null: false
    t.text     "course_prerequisites"
  end

  add_index "courses", ["instructor_id"], name: "index_courses_on_instructor_id", using: :btree
  add_index "courses", ["quarter_id"], name: "index_courses_on_quarter_id", using: :btree

  create_table "quarters", force: true do |t|
    t.integer  "year",                                       null: false
    t.string   "season"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "course_submission_deadline"
    t.datetime "student_bidding_deadline"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published",                  default: false, null: false
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "users", force: true do |t|
    t.string   "cnet"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "affiliation"
    t.string   "department"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "type",                   default: "", null: false
    t.integer  "number_of_courses",      default: 2,  null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
