Rails.application.routes.draw do

  root to: "users#index"

  devise_for :users, controllers: { 
  	users: "users", 
  	omniauth_callbacks: "omniauth_callbacks", 
  	registration: "users"}

  resources :users do
    get :subregion_options
  end
  resources :events do
  	get :join, 		  on: :member
  	get :unfollow, 	on: :member
  end

  mount Commontator::Engine => '/commontator'
 
end
