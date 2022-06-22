class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.belongs_to :player1
      t.belongs_to :player2
      t.string :game_name
      t.text :cards_deck, array: true, default: ["q0","q1", "q2", "q3", "q4", "q5", "q6", "q7", "q8","q9","c0","c1","c2","c3","c4","c5","c6","c7","c8","c9","f0","f1","f2","f3","f4","f5","f6","f7","f8","f9","p0","p1","p2","p3","p4","p5","p6","p7","p8","p9"] #la baraja de cartas
      t.text :cards_hand_p1, array: true, default: [] #mano del jugador 1
      t.text :cards_hand_p2, array: true, default: [] #mano del jugador 2
      t.text :cards_won_p1, array: true, default: []  #cartas ganada por el jugador 1
      t.text :cards_won_p2, array: true, default: [] #cartas ganada por el jugador 2
      t.text :cards_played, array: true, default: ["",""] #las cartas jugadas, las arribas de la mesa
      t.integer :active_player #para saber a quien le toca jugar
      t.integer :first_player #para saber cual jugador jugò primero en cada ronda, sirve para calcular puntos
      t.integer :points_player1, default: 0 #donde tengo la cuenta de los puntos del jugador 1
      t.integer :points_player2, default: 0 #donde tengo la cuenta de los puntos del jugador 2
      t.timestamps
    end
  end
end
