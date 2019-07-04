Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
root 'pages#index'
  get 'home' => 'pages#home'
  get 'test' => 'pages#test', :as => :test


end
