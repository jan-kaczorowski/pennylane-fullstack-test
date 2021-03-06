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

ActiveRecord::Schema.define(version: 2022_04_02_143112) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ingredients", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "recipe_ingredient_assignments", force: :cascade do |t|
    t.bigint "recipe_id"
    t.bigint "ingredient_id"
    t.integer "unit", null: false
    t.float "quantity", null: false
    t.string "original_row"
    t.index ["ingredient_id"], name: "index_recipe_ingredient_assignments_on_ingredient_id"
    t.index ["quantity"], name: "index_recipe_ingredient_assignments_on_quantity"
    t.index ["recipe_id"], name: "index_recipe_ingredient_assignments_on_recipe_id"
    t.index ["unit"], name: "index_recipe_ingredient_assignments_on_unit"
  end

  create_table "recipes", force: :cascade do |t|
    t.string "title"
    t.string "category"
    t.string "author"
    t.string "image_url"
    t.integer "cook_time"
    t.integer "prep_time"
    t.float "ratings"
    t.string "cuisine"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "recipe_ingredient_assignments", "ingredients"
  add_foreign_key "recipe_ingredient_assignments", "recipes"
end
