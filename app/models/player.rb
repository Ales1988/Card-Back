class Player < ApplicationRecord
     #callback
     before_create :set_token
     #Tengo que settear el token ante de crear el player, porque sino no lo guarda
 
   
     def set_token
     self.token=SecureRandom.uuid
     end
end
