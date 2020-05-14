Rails.application.routes.draw do
  resources :projects
  resources :pomodoros
  resources :links
  resources :nodes
  # resources :dashboard
  devise_for :users
  root "dashboard#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
