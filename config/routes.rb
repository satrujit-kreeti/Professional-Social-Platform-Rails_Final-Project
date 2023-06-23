Rails.application.routes.draw do
  get '/auth/linkedin/callback', to: 'sessions#linkedin', as: 'linkedin'

  root 'sessions#new'

  get '/login', to:'sessions#new'
  post '/login', to:'sessions#create'
  get '/logout', to:'sessions#destroy'
  get '/home', to: 'users#home'
  get '/profile', to: 'users#profile'




  get '/home/:id/profiles', to: 'users#profiles', as: 'user_profile'

  
  resources :users

  delete '/users/:id/delete_account', to: 'users#delete_account'


  get '/signup', to:'users#new'
  post '/signup', to:'users#create'
  get '/users/details/:id', to:'users#edit'
  patch '/users/details/:id', to:'users#update'





  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
