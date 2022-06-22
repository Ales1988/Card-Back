class Game < ApplicationRecord
    belongs_to :player1, class_name: "Player"
    belongs_to :player2, class_name: "Player", optional: true


    #Metodo de instancia para mezclar la baraja de cartas
    def shuffle_deck
        self.cards_deck=self.cards_deck.shuffle()
    end

    #Metodo de instancia para repartir las cartas
    def assign_cards
       3.times do #3 veces porque tengo que dar 3 cartas a cada jugador
        self.cards_hand_p1.append(self.cards_deck.first) #doy la primera carta de la baraja al jugador 1
        self.cards_deck.shift()                          #saco la primera carta de la baraja
        self.cards_hand_p2.append(self.cards_deck.first) #doy la primera carta de la baraja al jugador 2
        self.cards_deck.shift()                          #saco la primera carta de la baraja
       end
    end

    #metodo de instancia para contar puntos
    def points
        points=0
       
       #Siguiente bloque son los valores de las cartas
        if self.cards_played[0][1]=="9" #cards_played[0] es un string de dos caracters: el primero me dice el palo y el segundo el valor de la carta; 
            points=points+11            #cards_played[0][1] estoy selecionando el segundo caracter, el valor
        end
        if self.cards_played[0][1]=="8"
            points=points+10
        end
        if self.cards_played[0][1]=="7"
            points=points+4
        end
        if self.cards_played[0][1]=="6"
            points=points+3
        end
        if self.cards_played[0][1]=="5"
            points=points+2
        end
        if self.cards_played[1][1]=="9"
            points=points+11
        end
        if self.cards_played[1][1]=="8"
            points=points+10
        end
        if self.cards_played[1][1]=="7"
            points=points+4
        end
        if self.cards_played[1][1]=="6"
            points=points+3
        end
        if self.cards_played[1][1]=="5"
            points=points+2
        end
        
        #Siguiente bloque para ver quien gana los puntos

        #Si los palos de las dos cartas son iguales && la carta jugada por el jugador 1 vale mas de la jugada por el jugador 2 
       if (self.cards_played[0][0]==self.cards_played[1][0] && self.cards_played[0][1]>self.cards_played[1][1] )
            self.points_player1 = self.points_player1 + points #Entonces los puntos van al jugador 1
            self.first_player = self.player1_id #Como termina una ronda, tengo que setear el primero jugador de la proxima ronda. Empieza siempre quien ganò la ultima ronda
            self.active_player = self.player1_id #Tambien tengo que setear que el jugador activo al principio de la proxima ronda, va a ser el primer jugador de esa ronda
       end

        #Si los palos de las dos cartas son iguales && la carta jugada por el jugador 2 vale mas de la jugada por el jugador 1 
        if (self.cards_played[0][0]==self.cards_played[1][0] && self.cards_played[1][1]>self.cards_played[0][1] )
            self.points_player2 = self.points_player2 + points #Entonces los puntos van al jugador 2
            self.first_player = self.player2_id #Como termina una ronda, tengo que setear el primero jugador de la proxima ronda. Empieza siempre quien ganò la ultima ronda
            self.active_player = self.player2_id #Tambien tengo que setear que el jugador activo al principio de la proxima ronda, va a ser el primer jugador de esa ronda
       end
    
       #Si los palos de las dos cartas son distintos && la carta jugada per el jugador 1 es de diamantes
       if((self.cards_played[0][0]!=self.cards_played[1][0]) && (self.cards_played[0][0]=="q"))
        self.points_player1 = self.points_player1 + points #Entonces los puntos van al jugador 1
        self.first_player = self.player1_id #Como termina una ronda, tengo que setear el primero jugador de la proxima ronda. Empieza siempre quien ganò la ultima ronda
            self.active_player = self.player1_id #Tambien tengo que setear que el jugador activo al principio de la proxima ronda, va a ser el primer jugador de esa ronda
       end

       #Si los palos de las dos cartas son distintos && la carta jugada per el jugador 2 es de diamantes
       if((self.cards_played[0][0]!=self.cards_played[1][0]) && (self.cards_played[1][0]=="q"))
        self.points_player2 = self.points_player2 + points #Entonces los puntos van al jugador 2
        self.first_player = self.player2_id #Como termina una ronda, tengo que setear el primero jugador de la proxima ronda. Empieza siempre quien ganò la ultima ronda
            self.active_player = self.player2_id #Tambien tengo que setear que el jugador activo al principio de la proxima ronda, va a ser el primer jugador de esa ronda
       end

       #Si los palos de las dos cartas son distintos && la carta jugada por el jugador 1 NO es diamante && la carta jugada por el jugador 2 NO es diamante && el jugador 1 es el primero que ha jugado
       if((self.cards_played[0][0]!=self.cards_played[1][0])&&(self.cards_played[0][0]!="q")&&(self.cards_played[1][0]!="q")&&(self.first_player==self.player1_id))
        self.points_player1 = self.points_player1 + points #Entonces los puntos van al jugador 1
        self.first_player = self.player1_id #Como termina una ronda, tengo que setear el primero jugador de la proxima ronda. Empieza siempre quien ganò la ultima ronda
            self.active_player = self.player1_id #Tambien tengo que setear que el jugador activo al principio de la proxima ronda, va a ser el primer jugador de esa ronda
       end

       #Si los palos de las dos cartas son distintos && la carta jugada por el jugador 1 NO es diamante && la carta jugada por el jugador 2 NO es diamante && el jugador 2 es el primero que ha jugado
       if((self.cards_played[0][0]!=self.cards_played[1][0])&&(self.cards_played[0][0]!="q")&&(self.cards_played[1][0]!="q")&&(self.first_player==self.player2_id))
        self.points_player2 = self.points_player2 + points #Entonces los puntos van al jugador 2
        self.first_player = self.player2_id #Como termina una ronda, tengo que setear el primero jugador de la proxima ronda. Empieza siempre quien ganò la ultima ronda
            self.active_player = self.player2_id #Tambien tengo que setear que el jugador activo al principio de la proxima ronda, va a ser el primer jugador de esa ronda
       end

        
        
    end
end
