class ApplicationController < ActionController::Base
    skip_before_action :verify_authenticity_token #Sirve si o si, palabra de Gaby
end
