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

ActiveRecord::Schema.define(version: 2020_04_26_201731) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "classes", force: :cascade do |t|
    t.bigint "specialty_id", null: false
    t.bigint "faculty_id", null: false
    t.bigint "total_cost", null: false
    t.bigint "faculty_cut", null: false
    t.text "taught_via", null: false
    t.text "phyiscal_location_address"
    t.bigint "number_of_weeks", null: false
    t.bigint "occurs_on_for_a_given_week", null: false
    t.text "individual_session_starts_at", null: false
    t.bigint "per_session_minutes", null: false
    t.datetime "effective_from", null: false
    t.datetime "effective_unitl"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["faculty_id"], name: "index_classes_on_faculty_id"
    t.index ["specialty_id"], name: "index_classes_on_specialty_id"
  end

  create_table "faculties", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "bio", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_faculties_on_user_id"
  end

  create_table "family_members", force: :cascade do |t|
    t.bigint "parent_id", null: false
    t.bigint "student_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_family_members_on_parent_id"
    t.index ["student_id"], name: "index_family_members_on_student_id"
  end

  create_table "parents", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "address", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_parents_on_user_id"
  end

  create_table "registrations", force: :cascade do |t|
    t.bigint "class_id", null: false
    t.bigint "primary_family_member_id"
    t.bigint "secondary_family_member_id"
    t.bigint "tertiary_family_member_id"
    t.text "status", default: "processing", null: false
    t.bigint "total_due", null: false
    t.datetime "total_due_by", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["class_id"], name: "index_registrations_on_class_id"
    t.index ["primary_family_member_id"], name: "index_registrations_on_primary_family_member_id"
    t.index ["secondary_family_member_id"], name: "index_registrations_on_secondary_family_member_id"
    t.index ["tertiary_family_member_id"], name: "index_registrations_on_tertiary_family_member_id"
  end

  create_table "specialties", force: :cascade do |t|
    t.text "subject", null: false
    t.text "category", null: false
    t.text "focus_areas", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subject"], name: "index_specialties_on_subject"
  end

  create_table "students", force: :cascade do |t|
    t.text "first_name", null: false
    t.text "last_name", null: false
    t.text "nickname", null: false
    t.datetime "date_of_birth", null: false
    t.bigint "age"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.text "email", null: false
    t.text "first_name", null: false
    t.text "last_name", null: false
    t.text "user_name", null: false
    t.text "phone_number", null: false
    t.text "emergency_contact", null: false
    t.text "emergency_contact_phon_number", null: false
    t.text "timezone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "classes", "faculties"
  add_foreign_key "classes", "specialties"
  add_foreign_key "faculties", "users"
  add_foreign_key "family_members", "parents"
  add_foreign_key "family_members", "students"
  add_foreign_key "parents", "users"
  add_foreign_key "registrations", "classes"
end
