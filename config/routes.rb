Rails.application.routes.draw do
  scope "(:locale)", :locale => /en|vi/ do
    root "static_pages#home"
    get "/home", to: "static_pages#home"
    get "/help", to: "static_pages#help"
    get "/about", to: "static_pages#about"
    get "/contact", to: "static_pages#contact"
    get "/word", to: "static_pages#word"
    get "/signup", to: "users#new"
    get "/profile", to: "users#show"
    get "/edit", to: "users#edit"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
  end

  resources :users
  
end
