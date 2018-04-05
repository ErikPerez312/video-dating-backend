Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users

  get "/token", to: "tokens#index"
  get "/session", to: "sessions#index"

  get "/users/:user_id/matches",  to: "matches#index"
  get "/matches/:id", to: "matches#show"
  post "/users/:user_id/matches", to: "matches#create"
end
