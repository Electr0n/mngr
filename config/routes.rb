Rails.application.routes.draw do

  root to: "users#index"

  devise_for :users, controllers: { users: "users", omniauth_callbacks: "omniauth_callbacks" }
  
end
