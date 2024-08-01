Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' }

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'welcome#index'
  mount Fora::Engine => '/forum'

  get '/privacy', to: 'welcome#privacy', as: 'privacy'
  get '/cookies', to: 'welcome#cookies', as: 'cookies'
  get '/terms', to: 'welcome#terms', as: 'terms'
end
