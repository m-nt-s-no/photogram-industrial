Rails.application.routes.draw do
  # Defines the root path route ("/")
  root "photos#index"

  devise_for :users
  resources :comments
  resources :follow_requests
  resources :likes
  resources :photos

  get ":username/liked" => "users#liked", as: :liked
  get "/:username" => "users#show", as: :user
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
end
