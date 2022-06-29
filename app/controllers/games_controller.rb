class GamesController < ApplicationController

 #callback
    
 before_action :check_token, only:[ :create, :join, :take, :play] #check_token me permite recuperar el jugador que está ejecutando la request
 before_action :set_game, only:[ :show, :join, :take, :play]
 before_action :check_turn, only:[:take, :play] #Verifica que sea el turno del jugador que envia la request

 #actions
 #Este action me muestra todos los games existentes si no agrego parámetros de búsqueda.
 #También puedo usarlo para mostrar todos los juegos disponibles para el join si agrego el parámetro de solicitud search=nil.
 #"nil" porque los games disponibles son aquellos sin player2_id
 #Ej. http://127.0.0.1:3000/games?search=nil
 def index
     if params[:search]=="nil"
         @games = Game.where(player2_id: nil)
         render status: 200, json: {games: @games}
     else
         @games = Game.all
         render status: 200, json: {games: @games}
     end
 end

 def show
     render status: 200, json: {game: @game}
 end


 def create
     @game = Game.new() 
     @game.player1 = @player #player lo recupero en check_token
     @game.game_name = params[:game_name]
     
     game_save
 end

 #action para asignar el segundo jugador a un game y inicializar el game
 def join
     @game.player2 = @player #player lo recupero en el before_action check_token y game lo recupero con set_game
     @game.active_player = @game.player1_id #El primer player a jugar va a ser lo que creò el game
     @game.turns.create(turn_number: 1, first_player: @game.player1, second_player: @game.player2) #creo una nuova instancia de turn
     @game.shuffle_deck #Se mezcla la baraja de cartas
     @game.assign_cards #Se da la primera mano de cartas
     game_save
 end

 #Action  que permite a un jugador de sacar una carta
 def take
    return render status: 402, json: {message: "¡Ya tienes 3 cartas!"} if @player.id == @game.player1_id && @game.cards_hand_p1.length()>2
    return render status: 402, json: {message: "¡Ya tienes 3 cartas!"} if @player.id == @game.player2_id && @game.cards_hand_p2.length()>2
    return render status: 402, json: {message: "¡Se acabó el juego!"} if @game.cards_deck.length<1
    
    #Si el jugador que envia la request es el jugador 1
    if @player.id == @game.player1_id
        @game.cards_hand_p1.append(@game.cards_deck.shift()) #doy la primera carta de la baraja al jugador 1 y saco la primera carta de la baraja
    end
    #Si el jugador que envia la request es el jugador 2
    if @player.id == @game.player2_id
        @game.cards_hand_p2.append(@game.cards_deck.shift()) #doy la primera carta de la baraja al jugador 2 y saco la primera carta de la baraja
    end

    game_save
 end

 #Action que permite de jugar una ronda, recive params card_name
 def play
    
    #Metodo que pone la carta jugada en la mesa
    @game.play_card(@player.id,params[:card_name])

    #Si ambos jugaron, es decir termina una ronda
    if (@game.turns.last.first_card.present? && @game.turns.last.second_card.present?)#significa que ambos han ya jugado 
        

       #Averiguo cual jugador ganò la ronda pasando como argumento las dos cartas jugadas y el first y second player
       player_winner = Game.player_win(@game.turns.last.first_card, @game.turns.last.second_card, @game.turns.last.first_player, @game.turns.last.second_player)
        
       #Calculo cuantos puntos se ganan en esta ronda
       points_turn = Game.calculate_points(@game.turns.last.first_card, @game.turns.last.second_card)
        
       #Asigno los puntos de la ronda al ganador
        if(player_winner==@game.player1)#Si el ganador es el player 1
            @game.points_player1 = @game.points_player1 + points_turn #Asigno los puntos de la ronda al player 1
            @game.active_player=@game.player1_id #Si ganò el player 1, el proximo a jugar es el player 1

            #Creo el nuevo turno. Como ganò el player 1, el first_player va a ser el player 1
            @game.turns.create(turn_number: @game.turns.last.turn_number+1, first_player: @game.player1, second_player: @game.player2)

        else#Si el ganador es el player 2
            @game.points_player2 = @game.points_player2 + points_turn #Asigno los puntos de la ronda al player 2
            @game.active_player=@game.player2_id #Si ganò el player 2, el proximo a jugar es el player 2

            #Creo el nuevo turno. Como ganò el player 2, el first_player va a ser el player 2
            @game.turns.create(turn_number: @game.turns.last.turn_number+1, first_player: @game.player2, second_player: @game.player1)
        end
    

    else #Sino, la ronda no he terminada: solo un jugador jugò. Tengo que cambiar solo  el active_player para hacer jugar el jugador que no jugò
        if (@player.id==@game.player1_id) #paso el turno al otro jugador, el first_player no cambia, porque se llega a esta linea de codigo significa que la ronda no terminò
            @game.active_player=@game.player2_id
        else
            @game.active_player=@game.player1_id
        end
    end

    game_save
end


 def game_save
     if @game.save 
         
         render status: 200, json: {game: @game}
     else
         render status: 400, json: {message: @game.errors.details}
     end
 end

 def set_game
     @game=Game.find_by(id: params[:id]) 
     return if @game.present? 

     render status: 404, json: { message: "No esta #{params[:id]}"}
     false 
 end

 #Verifica la identidad del usuario a través del token que envía el front (después de haberlo guardado gracias al login)
 def check_token
     token = request.headers["Authorization"].split(" ") 
     @player=Player.find_by(token: token[1])#En token[1] queda el token de verdad

     return if @player.present?
    
     render status: 401, json:{message: "Debe iniciar sesión con un usuario válido"}
     false #false necesario para que no se ejecute el action que ha llamado check_token como callback
 end

 #Verifica que sea el turno del jugador que envia la request
 def check_turn
    return if @player.id == @game.active_player

    render status: 402, json:{message: "No es tu turno!"}
    false
 end

end
