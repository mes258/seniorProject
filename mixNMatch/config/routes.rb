Rails.application.routes.draw do
  resources :profiles
  post 'profiles/:id' => "profiles#show"
  get 'sessions/new'
  get 'users/new'
  get 'welcome/index'
  get 'matches/index'
  get 'matches/update_status'
  post 'matches/update_status'
  get "log_out" => "sessions#destroy", :as => "log_out"
  get "log_in" => "sessions#new", :as => "log_in"
  get "sign_up" => "users#new", :as => "sign_up"
  get "users/:id" => "users#show", :as => "show_user"
  root :to => "sessions#new"
  resources :matches
  resources :users
  resources :sessions
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #root 'welcome#index'
end
