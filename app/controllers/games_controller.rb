class GamesController < ApplicationController

 #callback
    
 before_action :check_token, only:[ :create, :join, :draft, :play] #check_token me permite recuperar el jugador que está ejecutando la request
 before_action :set_game, only:[ :show, :join, :draft, :play]
 before_action :check_turn, only:[:draft, :play] #Verifica que sea el turno del jugador que envia la request

 #actions
 #Este action me muestra todos los games existentes si no agrego parámetros de búsqueda.
 #También puedo usarlo para mostrar todos los juegos disponibles para el join si agrego el parámetro de solicitud search= . Sin nada porque 
 #los games disponibles son aquellos sin player2_id
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

 #action para asignar el segundo jugador a un game
 def join
     @game.player2 = @player #player lo recupero en el before_action check_token y game lo recupero con set_game
     @game.active_player = @game.player1_id #El primer player a jugar va a ser lo que creò el game
     @game.first_player = @game.player1_id #El jugador que creò el game a a ser el first player de la primera ronda. La diferencia con active_player es que durante una ronda, el active_player va a cambiar.
     @game.shuffle_deck #Se mezcla la baraja de cartas
     @game.assign_cards #Se da la primera mano de cartas
     game_save
 end

 #Action para que permite a un jugador de robar una carta
 def draft
    return render status: 402, json: {message: "¡Ya tienes 3 cartas!"} if @player.id == @game.player1_id && @game.cards_hand_p1.length()>2
    return render status: 402, json: {message: "¡Ya tienes 3 cartas!"} if @player.id == @game.player2_id && @game.cards_hand_p2.length()>2
    return render status: 402, json: {message: "¡Se acabó el juego!"} if @game.cards_deck.length<1
    
    if @player.id == @game.player1_id
        @game.cards_hand_p1.append(@game.cards_deck.first) #doy la primera carta de la baraja al jugador 1
        @game.cards_deck.shift()                          #saco la primera carta de la baraja
    end
    if @player.id == @game.player2_id
        @game.cards_hand_p2.append(@game.cards_deck.first) #doy la primera carta de la baraja al jugador 2
        @game.cards_deck.shift()                          #saco la primera carta de la baraja
    end

    game_save
 end

 #Action que permite de jugar una carta, recive params card_name
 def play
    return render status: 403, json: {message: "¡Ya has jugado una carta!"} if @player.id == @game.player1_id && @game.cards_played[0]!=""
    return render status: 403, json: {message: "¡Ya has jugado una carta!"} if @player.id == @game.player2_id && @game.cards_played[1]!=""
    
    #Si està jugando el player1
    if (@player.id==@game.player1_id)
    @game.cards_played[0]=params[:card_name] #Pongo la carta jugada en la mesa
    @game.cards_hand_p1.delete(params[:card_name]) #Saco la carta jugada de la mano del jugador
    end
    
    #Si està jugando el player2
    if (@player.id==@game.player2_id)
        @game.cards_played[1]=params[:card_name] #Pongo la carta jugada en la mesa
        @game.cards_hand_p2.delete(params[:card_name]) #Saco la carta jugada de la mano del jugador
    end

    #Si ambos jugaron, es decir termina una ronda
    if (@game.cards_played[0]!="" && @game.cards_played[1]!="")#significa que ambos han ya jugado
        

        #Como termina una ronda, calculo los puntos
        @game.points()
        @game.cards_played[0]=""
        @game.cards_played[1]="" #quito ambas cartas de la mesa para prepararme a la proxima ronda
    

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
