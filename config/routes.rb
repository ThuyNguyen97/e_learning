Rails.application.routes.draw do
  root "users#new"
  get "/signup", to: "users#new"
  get "/profile", to: "users#show"

  resources :users
end
