class CreateTurns < ActiveRecord::Migration[7.0]
  def change
    create_table :turns do |t|
      t.belongs_to :game
      t.integer :turn_number
      t.belongs_to :first_player
      t.belongs_to :second_player
      t.string :first_card
      t.string :second_card
      t.timestamps
    end
  end
end
