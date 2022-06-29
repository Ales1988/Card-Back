class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.belongs_to :player1
      t.belongs_to :player2
      t.string :game_name                         #la baraja de cartas
      t.text :cards_deck, array: true, default: ["diamante1", "diamante3", "diamante_rey", "diamante_reina", 
                                                "diamante_jota", "diamante7", "diamante6", "diamante5", "diamante4", 
                                                "diamante2", "trebole1", "trebole3", "trebole_rey", "trebole_reina", 
                                                "trebole_jota", "trebole7", "trebole6", "trebole5", "trebole4", 
                                                "trebole2", "corazone1", "corazone3", "corazone_rey", "corazone_reina", 
                                                "corazone_jota", "corazone7", "corazone6", "corazone5", "corazone4", 
                                                "corazone2","pica1", "pica3", "pica_rey", "pica_reina", "pica_jota", 
                                                "pica7", "pica6", "pica5", "pica4", "pica2"] 

      t.text :cards_hand_p1, array: true, default: [] #mano del jugador 1
      t.text :cards_hand_p2, array: true, default: [] #mano del jugador 2
      t.integer :active_player #para saber a quien le toca jugar
      t.integer :points_player1, default: 0 #donde tengo la cuenta de los puntos del jugador 1
      t.integer :points_player2, default: 0 #donde tengo la cuenta de los puntos del jugador 2
      t.timestamps
    end
  end
end
