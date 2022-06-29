Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :players, except: [:destroy, :new, :edit] do
    member do
      get :login
      put :change_password
    end
  end

  resources :games, except: [:update, :destroy, :new, :edit] do

    member do
      put :join
      put :take
      put :play
    end
  end

  resources :turns, except: [:destroy, :new, :edit]
  

end
