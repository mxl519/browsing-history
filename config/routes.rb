Rails.application.routes.draw do
  devise_for :users

  root to: "application#index"

  get '/apps', to: 'app#index'

  post '/history', to: 'apps_users#create'
  get '/apps_users', to: 'apps_users#index'
end
