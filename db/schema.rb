# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2026_06_14_021301) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "device_grades", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "devices", force: :cascade do |t|
    t.bigint "maker_id", null: false
    t.bigint "device_grade_id", null: false
    t.string "name"
    t.integer "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["device_grade_id"], name: "index_devices_on_device_grade_id"
    t.index ["maker_id"], name: "index_devices_on_maker_id"
  end

  create_table "discount_plan_brands", force: :cascade do |t|
    t.bigint "discount_id", null: false
    t.bigint "plan_brand_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discount_id"], name: "index_discount_plan_brands_on_discount_id"
    t.index ["plan_brand_id"], name: "index_discount_plan_brands_on_plan_brand_id"
  end

  create_table "discounts", force: :cascade do |t|
    t.string "name"
    t.integer "amount"
    t.integer "duration_months"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "group_name"
  end

  create_table "makers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "options", force: :cascade do |t|
    t.string "name"
    t.integer "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plan_brand_plans", force: :cascade do |t|
    t.bigint "plan_id", null: false
    t.bigint "plan_brand_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_brand_id"], name: "index_plan_brand_plans_on_plan_brand_id"
    t.index ["plan_id"], name: "index_plan_brand_plans_on_plan_id"
  end

  create_table "plan_brands", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plans", force: :cascade do |t|
    t.string "name"
    t.integer "monthly_fee"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string "name"
    t.integer "monthly_fee"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "password_digest"
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_users_on_name", unique: true
  end

  add_foreign_key "devices", "device_grades"
  add_foreign_key "devices", "makers"
  add_foreign_key "discount_plan_brands", "discounts"
  add_foreign_key "discount_plan_brands", "plan_brands"
  add_foreign_key "plan_brand_plans", "plan_brands"
  add_foreign_key "plan_brand_plans", "plans"
end
