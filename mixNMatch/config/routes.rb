Rails.application.routes.draw do
  resources :profiles
  get 'sessions/new'
  get 'users/new'
  get 'welcome/index'
  get "log_out" => "sessions#destroy", :as => "log_out"
  get "log_in" => "sessions#new", :as => "log_in"
  get "sign_up" => "users#new", :as => "sign_up"
  root :to => "users#new"
  resources :users
  resources :sessions
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #root 'welcome#index'
end
