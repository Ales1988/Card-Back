class PlayersController < ApplicationController
   
	before_action :check_token, only: [ :show, :change_password]
    
    def index
        @players = Player.all
        render status: 200, json: {players: @players}
    end

    def show
        render status: 200, json: {player: @player}
    end

    def create
        @player = Player.new(player_params) 
        player_save
    end

    #En el login el usuario introduce nombre y contraseña para recuperar el token que se guarda en la sesión del front
    #Ej request http://127.0.0.1:3000/players/Ale/login?password=ale
    def login
         @player=Player.where(name: params[:id], password: params[:password])
         if @player.present?
            render status: 200, json: {player: @player.first} #Retorno solo el primer jugadar, habria que ver como hacer univoco name + password
         else
            render status: 404, json: {message: "No existe el jugador o la contraseña es incorrecta."}
         end
    end

    #Action que permite a un jugador de cambiar password
    def change_password
        if @player.password==params[:current_password]
            @player.password=params[:new_password]
            player_save
        else
            render status: 400, json: {message: "La passoword ingresada no es corecta!"}
        end
    end
   
    def player_params
        params.require(:player).permit(:name, :password)
    end

   
    def player_save
        if @player.save
            render status: 200, json: {player: @player}
        else
            render status: 400, json: {message: @player.errors.dettails}
        end
    end

    #Verifica la identidad del usuario a través del token que envía el front (después de haberlo guardado gracias al login)
    def check_token
        token = request.headers["Authorization"].split(" ") #Tengo que usar split porque el front envía "Bearer token" y solo necesito el token.
        @player=Player.find_by(token: token[1])#En token[0] queda "Bearer"

        return if @player.present?
        
        render status: 401, json:{message: "Debe iniciar sesión con un usuario válido"}#Si llega a esta línea de código, significa que se ha introducido manualmente un token incorrecto en el front en lugar de seguir el procedimiento normal de inicio de sesión
        false #false necesario para que no se ejecute el action que ha llamado check_token como callback
    end
end
