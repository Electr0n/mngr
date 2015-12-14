Rails.application.routes.draw do

  root to: "users#index"

  devise_for :users, controllers: { 
  	users: "users", 
  	omniauth_callbacks: "omniauth_callbacks", 
  	registration: "users"}

  resources :users
  resources :events do
  	get :join, 		  on: :member
  	get :unfollow, 	on: :member
  end
  
end
