Rails.application.routes.draw do

  root to: "users#index"

  get '/help' => 'application#help'
  get '/media' => 'application#media'
  get '/peoples' => 'application#peoples'

  devise_for :users, controllers: { 
    users: "users", 
    omniauth_callbacks: "omniauth_callbacks", 
    registrations: "users"
    }

  resources :users do
    get :city_search
    get :subregion_options
    get :del_request, on: :member
  end
  resources :events do
    get :join,        on: :member
    get :unfollow,    on: :member
    get :del_request, on: :member
  end
  resources :tags do
  end
  resources :admin do
    get :users, on: :collection
  end

  mount Commontator::Engine => '/commontator'
 
end
