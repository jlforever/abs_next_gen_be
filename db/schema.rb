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

ActiveRecord::Schema.define(version: 2020_12_05_195438) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "class_session_materials", force: :cascade do |t|
    t.bigint "class_session_id", null: false
    t.text "name", null: false
    t.text "audience", null: false
    t.text "mime_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "teaching_session_student_upload_id"
    t.index ["class_session_id"], name: "index_class_session_materials_on_class_session_id"
    t.index ["teaching_session_student_upload_id"], name: "idx_class_sessions_on_teaching_session_student_upload"
  end

  create_table "class_sessions", force: :cascade do |t|
    t.bigint "registration_id", null: false
    t.text "status", null: false
    t.datetime "effective_for", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "associate_teaching_session_id"
    t.index ["associate_teaching_session_id"], name: "index_class_sessions_on_associate_teaching_session_id"
    t.index ["registration_id"], name: "index_class_sessions_on_registration_id"
  end

  create_table "credit_cards", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "card_holder_name", null: false
    t.text "card_last_four", null: false
    t.text "card_type", null: false
    t.text "card_expire_month", null: false
    t.text "card_expire_year", null: false
    t.text "stripe_customer_token"
    t.text "stripe_card_token"
    t.text "postal_identification"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_credit_cards_on_user_id"
  end

  create_table "faculties", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "bio", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "name", null: false
    t.text "address1"
    t.text "address2"
    t.text "city"
    t.text "state"
    t.text "zip"
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

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "klass_vacay_dates", force: :cascade do |t|
    t.bigint "klass_id", null: false
    t.text "off_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["klass_id"], name: "index_klass_vacay_dates_on_klass_id"
  end

  create_table "klasses", force: :cascade do |t|
    t.bigint "specialty_id", null: false
    t.bigint "faculty_id", null: false
    t.bigint "per_session_student_cost", null: false
    t.bigint "per_session_faulty_cut", null: false
    t.text "taught_via", null: false
    t.text "phyiscal_location_address"
    t.bigint "number_of_weeks", null: false
    t.text "occurs_on_for_a_given_week", null: false
    t.text "individual_session_starts_at", null: false
    t.bigint "per_session_minutes", null: false
    t.datetime "effective_from", null: false
    t.datetime "effective_until"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "one_sibling_same_class_discount_rate"
    t.float "two_siblings_same_class_discount_rate"
    t.text "virtual_klass_platform_link"
    t.text "code"
    t.datetime "reg_effective_from"
    t.datetime "reg_effective_until"
    t.integer "student_capacity", default: 100, null: false
    t.integer "capacity", default: 20, null: false
    t.index ["code"], name: "index_klasses_on_code"
    t.index ["effective_from", "effective_until"], name: "idx_klasses_on_effective_from_to_until"
    t.index ["faculty_id", "specialty_id", "effective_from"], name: "idx_klasses_on_uniq_faculty_specialty_start_time", unique: true
    t.index ["faculty_id"], name: "index_klasses_on_faculty_id"
    t.index ["reg_effective_from"], name: "index_klasses_on_reg_effective_from"
    t.index ["reg_effective_until"], name: "index_klasses_on_reg_effective_until"
    t.index ["specialty_id"], name: "index_klasses_on_specialty_id"
    t.index ["taught_via"], name: "index_klasses_on_taught_via"
  end

  create_table "parents", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "address1"
    t.text "address2"
    t.text "city"
    t.text "state"
    t.text "zip"
    t.text "emergency_contact"
    t.text "emergency_contact_phone_number"
    t.index ["user_id"], name: "index_parents_on_user_id", unique: true
  end

  create_table "registration_credit_card_charges", force: :cascade do |t|
    t.bigint "registration_id", null: false
    t.bigint "credit_card_id", null: false
    t.text "charge_id", null: false
    t.integer "amount", null: false
    t.jsonb "charge_outcome", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["credit_card_id"], name: "idx_reg_credit_card_charge_on_credit_card"
    t.index ["registration_id"], name: "idx_reg_credit_card_charge_on_reg"
  end

  create_table "registrations", force: :cascade do |t|
    t.bigint "klass_id", null: false
    t.bigint "primary_family_member_id"
    t.bigint "secondary_family_member_id"
    t.bigint "tertiary_family_member_id"
    t.text "status", default: "processing", null: false
    t.bigint "total_due", null: false
    t.datetime "total_due_by", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "accept_release_form", default: false, null: false
    t.index ["klass_id", "primary_family_member_id"], name: "idx_registrations_on_uniq_klass_primary_family_member", unique: true
    t.index ["klass_id"], name: "index_registrations_on_klass_id"
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
    t.text "nickname"
    t.datetime "date_of_birth", null: false
    t.bigint "age"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teaching_session_student_uploads", force: :cascade do |t|
    t.bigint "teaching_session_id", null: false
    t.text "name", null: false
    t.text "mime_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["teaching_session_id"], name: "idx_ts_student_uploads_on_ts"
  end

  create_table "teaching_sessions", force: :cascade do |t|
    t.bigint "klass_id", null: false
    t.datetime "effective_for", null: false
    t.text "corresponding_class_session_title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["klass_id"], name: "index_teaching_sessions_on_klass_id"
  end

  create_table "users", force: :cascade do |t|
    t.text "email", null: false
    t.text "first_name"
    t.text "last_name"
    t.text "user_name"
    t.text "phone_number"
    t.text "emergency_contact"
    t.text "emergency_contact_phone_number"
    t.text "timezone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "password_hash", null: false
    t.string "slug"
    t.string "password_reset_token"
    t.datetime "password_reset_token_expires_at"
    t.text "address1"
    t.text "address2"
    t.text "city"
    t.text "state"
    t.text "zip"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["password_reset_token"], name: "index_users_on_password_reset_token", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
  end

  add_foreign_key "class_session_materials", "class_sessions"
  add_foreign_key "class_sessions", "registrations"
  add_foreign_key "class_sessions", "teaching_sessions", column: "associate_teaching_session_id"
  add_foreign_key "credit_cards", "users"
  add_foreign_key "faculties", "users"
  add_foreign_key "family_members", "parents"
  add_foreign_key "family_members", "students"
  add_foreign_key "klass_vacay_dates", "klasses"
  add_foreign_key "klasses", "faculties"
  add_foreign_key "klasses", "specialties"
  add_foreign_key "parents", "users"
  add_foreign_key "registration_credit_card_charges", "credit_cards"
  add_foreign_key "registration_credit_card_charges", "registrations"
  add_foreign_key "registrations", "klasses"
  add_foreign_key "teaching_session_student_uploads", "teaching_sessions"
  add_foreign_key "teaching_sessions", "klasses"
end
