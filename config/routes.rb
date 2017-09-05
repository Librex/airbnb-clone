Rails.application.routes.draw do
  
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, :path => '', 
            :path_names => {:sign_in => 'login', :sign_out => 'logout', :edit => 'profile'},
            :controllers => {:registrations => 'registrations', :confirmations => 'confirmations'}
            
  root 'pages#home'
  
  resources :users, only: [:show]
  
  resources :rooms do
    resources :reservations, only: [:create]
    resources :reviews, only: [:create, :destroy]
  end

  resources :photos
  
  resources :conversations, only: [:index, :create] do
    resources :messages, only: [:index, :create]
  end

  get '/preload' => 'reservations#preload'
  get '/preview' => 'reservations#preview'
  get '/your_trips' => 'reservations#your_trips'
  get '/your_reservations' => 'reservations#your_reservations'
  get '/search' => 'pages#search'

if Rails.env.development?
  mount LetterOpenerWeb::Engine, at: "/letter_opener"
end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
