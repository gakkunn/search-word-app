Rails.application.routes.draw do
  devise_for :users
  root 'blocks#index'
  resources :blocks
end
