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

ActiveRecord::Schema[7.0].define(version: 2022_06_25_203720) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.bigint "player1_id"
    t.bigint "player2_id"
    t.string "game_name"
    t.text "cards_deck", default: ["diamante1", "diamante3", "diamante_rey", "diamante_reina", "diamante_jota", "diamante7", "diamante6", "diamante5", "diamante4", "diamante2", "trebole1", "trebole3", "trebole_rey", "trebole_reina", "trebole_jota", "trebole7", "trebole6", "trebole5", "trebole4", "trebole2", "corazone1", "corazone3", "corazone_rey", "corazone_reina", "corazone_jota", "corazone7", "corazone6", "corazone5", "corazone4", "corazone2", "pica1", "pica3", "pica_rey", "pica_reina", "pica_jota", "pica7", "pica6", "pica5", "pica4", "pica2"], array: true
    t.text "cards_hand_p1", default: [], array: true
    t.text "cards_hand_p2", default: [], array: true
    t.integer "active_player"
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

  create_table "turns", force: :cascade do |t|
    t.bigint "game_id"
    t.integer "turn_number"
    t.bigint "first_player_id"
    t.bigint "second_player_id"
    t.string "first_card"
    t.string "second_card"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["first_player_id"], name: "index_turns_on_first_player_id"
    t.index ["game_id"], name: "index_turns_on_game_id"
    t.index ["second_player_id"], name: "index_turns_on_second_player_id"
  end

end
