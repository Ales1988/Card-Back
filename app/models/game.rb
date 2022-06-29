class Game < ApplicationRecord
    belongs_to :player1, class_name: "Player"
    belongs_to :player2, class_name: "Player", optional: true
    has_many :turns

    #Diccionario que me dice cuántos puntos vale una carta
    POINTS =  { "diamante1": 11, 
                "diamante3": 10, 
                "diamante_rey": 4, 
                "diamante_reina": 3, 
                "diamante_jota": 2, 
                "diamante7": 0, 
                "diamante6": 0, 
                "diamante5": 0, 
                "diamante4": 0, 
                "diamante2": 0,
                "trebole1": 11, 
                "trebole3": 10, 
                "trebole_rey": 4, 
                "trebole_reina": 3, 
                "trebole_jota": 2, 
                "trebole7": 0, 
                "trebole6": 0, 
                "trebole5": 0, 
                "trebole4": 0, 
                "trebole2": 0,
                "corazone1": 11, 
                "corazone3": 10, 
                "corazone_rey": 4, 
                "corazone_reina": 3, 
                "corazone_jota": 2, 
                "corazone7": 0, 
                "corazone6": 0, 
                "corazone5": 0, 
                "corazone4": 0, 
                "corazone2": 0,
                "pica1": 11, 
                "pica3": 10, 
                "pica_rey": 4, 
                "pica_reina": 3, 
                "pica_jota": 2, 
                "pica7": 0, 
                "pica6": 0, 
                "pica5": 0, 
                "pica4": 0, 
                "pica2": 0}
                

    #
    #Diccionario que me dice qué carta gana sin considerar el palo
    #Lo necesito porque, por ejemplo, un cuatro (vale 0 puntos) gana a un dos (vale 0 puntos). Así que no puedo usar los puntos para decidir quién gana.
    WINS = { "diamante1": 9,     #Gana a las otras nueves cartas que la siguen
             "diamante3": 8,     #Gana a las otras ochos cartas que la siguen
             "diamante_rey": 7,   #Gana a las otras sietes cartas que la siguen
             "diamante_reina": 6, #Ecc
             "diamante_jota": 5,  #De esta forma puedo preguntar diamante3>diamante4 Y me responde:  diamante3 es mayor, entonces gana
             "diamante7": 4,     #Es más comprensible de lo que tenia ante 8 > 1 (Nota: 8 seria diamante3, 1 seria diamante4)
             "diamante6": 3, 
             "diamante5": 2, 
             "diamante4": 1, 
             "diamante2": 0,
             "trebole1": 9, 
             "trebole3": 8, 
             "trebole_rey": 7, 
             "trebole_reina": 6, 
             "trebole_jota": 5, 
             "trebole7": 4, 
             "trebole6": 3, 
             "trebole5": 2, 
             "trebole4": 1, 
             "trebole2": 0,
             "corazone1": 9, 
             "corazone3": 8, 
             "corazone_rey": 7, 
             "corazone_reina": 6, 
             "corazone_jota": 5, 
             "corazone7": 4, 
             "corazone6": 3, 
             "corazone5": 2, 
             "corazone4": 1, 
             "corazone2": 0,
             "pica1": 9, 
             "pica3": 8, 
             "pica_rey": 7, 
             "pica_reina": 6, 
             "pica_jota": 5, 
             "pica7": 4, 
             "pica6": 3, 
             "pica5": 2, 
             "pica4": 1, 
             "pica2": 0}


    #Metodo de instancia para mezclar la baraja de cartas
    def shuffle_deck
        self.cards_deck=self.cards_deck.shuffle()
    end

    #Metodo de instancia para repartir las cartas al principio de la partida
    def assign_cards
       3.times do #3 veces porque tengo que dar 3 cartas a cada jugador
        self.cards_hand_p1.append(self.cards_deck.shift()) #doy la primera carta de la baraja al jugador 1 y saco la primera carta de la baraja
        self.cards_hand_p2.append(self.cards_deck.shift() ) #doy la primera carta de la baraja al jugador 2 y saco la primera carta de la baraja
       end
    end

    #Metodo de instancia que permite a un jugador de jugar una carta en la mesa
    def play_card(player_id, card_played)

        if (player_id==self.turns.last.first_player_id)
            self.turns.last.update(first_card: card_played) #Pongo la carta jugada en la mesa
        else
            self.turns.last.update(second_card: card_played) #Pongo la carta jugada en la mesa
        end
      
        #Si està jugando el player1
        if (player_id==self.player1_id)       
            self.cards_hand_p1.delete(card_played) #Saco la carta jugada de la mano del jugador 1
        end
        
        #Si està jugando el player2
        if (player_id==self.player2_id)
            self.cards_hand_p2.delete(card_played) #Saco la carta jugada de la mano del jugador 2
        end

    end
    
    #metodo de clase para calcular puntos
    def self.calculate_points(card1, card2)
        return score = POINTS[card1.to_sym] + POINTS[card2.to_sym]
    end

    #Metodo de clase para averiguar cual jugador gana. El orden de los argumentos es importante
    def self.player_win(card1, card2, first_player, second_player)
        
        #Si el palo es distinto
        if card1[0]!=card2[0]

            return first_player if card1[0] == "d" #Si la carta1 es de diamante gana el first_player porque diamante siempre gana
            return second_player if card2[0] == "d" #Si la carta2 es de diamante gana el second_player porque diamante siempre gana
            return first_player #Si llegamos a esta linea, no hay diamantes involucrados. Entonces gana first_player porque fue el primero a jugar

        else #Si entra en el else, significa que el palo es igual
            #NO puedo usar POINTS porque POINTS y WINS tienen valores distintos
            return first_player if Game::WINS[card1.to_sym]>Game::WINS[card2.to_sym] #Si la fuerza de la carta1 es mayor a lo de la carta2, gana first_player
            return second_player if Game::WINS[card2.to_sym]>Game::WINS[card1.to_sym] #Si la fuerza de la carta2 es mayor a lo de la carta1, gana second_player
        end

    end
       
end
