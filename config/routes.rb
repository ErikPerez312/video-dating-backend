Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users

  get "/token", to: "tokens#index"

  get "/session", to: "sessions#index"

  get "/users/:user_id/matches",  to: "matches#index"
  get "/matches/:id", to: "matches#show"
  post "/users/:user_id/matches", to: "matches#create"

  get "/users/:user_id/profile_images", to: "profile_images#index"
  post "/users/:user_id/profile_images", to: "profile_images#create"
  patch "/users/:user_id/profile_images/:id", to: "profile_images#update"
  delete "/users/:user_id/profile_images/:id", to: "profile_images#destroy"

  get "/random_user", to: "chats#show"
  get "/online_users", to: "chats#index"

  # Action Cable will be listening for WebSocket requests on ws://localhost:3000/cable.
  mount ActionCable.server => "/cable"
end
