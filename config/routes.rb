Rails.application.routes.draw do

  root to: "users#index"

  devise_for :users, controllers: { 
    users: "users", 
    omniauth_callbacks: "omniauth_callbacks", 
    registrations: "users"
    }

  resources :users do
    get :subregion_options
    get :del_request, on: :member
  end
  resources :events do
    get :join,        on: :member
    get :unfollow,    on: :member
  end
  resources :tags do
  end

  mount Commontator::Engine => '/commontator'
 
end
