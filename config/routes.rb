Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root	'users#new'

  get 'signup', to: 'users#new'
  resources :users, except: [:new]

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resources :lists

  resources :lists do
    member do
        get :flop
        post :add_product
        put :remove_product
        get :search_product
        post :vote
        put :unvote
    end
  end
end
