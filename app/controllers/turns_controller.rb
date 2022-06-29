class TurnsController < ApplicationController

    before_action :set_last_turn, only:[ :show]

    #Muestra todo los turns o todo los turns de un game especifico
    def index
           if params[:game].present?  #Si en el get està presente el parametro :game
            @turns = Turn.where(game_id: params[:game]) #busca solo los turns con game_id = al parametro
            render status: 200, json: {turns: @turns}  
           else
            @turns = Turn.all
            render status: 200, json: {turns: @turns}   
           end  
    end

    def show
        render status: 200, json: {turn: @turn}
    end

    #El game a lo cual pertenece el turn lo setea en autoatico rails gracias a la associaciòn
    def create
        @turn = Turn.new() 
        @turn.turn_number = params[:turn_number]
        @turn.first_player = params[:first_player]
        @turn.second_player = params[:second_player]
    
        
        turn_save
    end

    def turn_save
        if @turn.save 
            
            render status: 200, json: {turn: @turn}
        else
            render status: 400, json: {message: @turn.errors.details}
        end
    end

    #Me devuelve el ultimo turn del game que llega como parametro desde el front.
    #Me interesa el ultimo turn porque seria el turn en curso, 
    #entonces es lo que tiene toda la informaciòn para calcular el ganador y los puntos del turno
    def set_last_turn
        @turn=Turn.where(game_id: params[:id]).last 
        return if @turn.present? 
   
        render status: 404, json: { message: "No esta #{params[:id]}"}
        false
    end

end
