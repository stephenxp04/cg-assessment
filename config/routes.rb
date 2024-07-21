Rails.application.routes.draw do
  # Define explicit routes first
  resources :urls, only: [:destroy, :index, :create]
  
  # Change the root route to point directly to the index action
  root "urls#index"

  get "/up/", to: "up#index", as: :up
  get "/up/databases", to: "up#databases", as: :up_databases
  get "/swap", to: "pages#swap"
  get "/mana", to: "pages#mana"

  get '/usage_report', to: 'urls#usage_report'

  # Add more explicit routes here if needed

  # Ensure the dynamic route is at the bottom
  get "/:id", to: "urls#show", as: :short_url
end