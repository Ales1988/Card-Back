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

ActiveRecord::Schema[7.0].define(version: 2022_06_20_143139) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.bigint "player1_id"
    t.bigint "player2_id"
    t.string "game_name"
    t.text "cards_deck", default: ["q0", "q1", "q2", "q3", "q4", "q5", "q6", "q7", "q8", "q9", "c0", "c1", "c2", "c3", "c4", "c5", "c6", "c7", "c8", "c9", "f0", "f1", "f2", "f3", "f4", "f5", "f6", "f7", "f8", "f9", "p0", "p1", "p2", "p3", "p4", "p5", "p6", "p7", "p8", "p9"], array: true
    t.text "cards_hand_p1", default: [], array: true
    t.text "cards_hand_p2", default: [], array: true
    t.text "cards_won_p1", default: [], array: true
    t.text "cards_won_p2", default: [], array: true
    t.text "cards_played", default: ["", ""], array: true
    t.integer "active_player"
    t.integer "first_player"
    t.integer "points_player1", default: 0
    t.integer "points_player2", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player1_id"], name: "index_games_on_player1_id"
    t.index ["player2_id"], name: "index_games_on_player2_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.string "password"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
