Rails.application.routes.draw do
  get '/auth/linkedin/callback', to: 'sessions#linkedin', as: 'linkedin'

  root 'sessions#new'



  get '/login', to:'sessions#new'
  post '/login', to:'sessions#create'
  get '/logout', to:'sessions#destroy'
  get '/home', to: 'users#home'

  get '/users/details/:id', to:'users#edit', as: 'edit_user'
  patch '/users/details/:id', to:'users#update'

  # delete '/users/:id/delete_account', to: 'users#delete_account', as: 'delete_account'
  match '/users/:id/delete_account', to: 'users#delete_account', via: [:delete, :get], as: 'delete_account'


  get '/profile', to: 'users#profile'


  
  get '/home/:id/profiles', to: 'users#profiles', as: 'user_profile'

  resources :users do
    member do
      get 'connect', to: 'users#connect'
      post 'connect', to: 'users#connect'

      # delete 'disconnect', to: 'users#disconnect'
      # delete 'disconnect', to: 'users#disconnect', as: 'disconnect'
      match 'disconnect', to: 'users#disconnect', via: [:delete, :get]
    end
    get 'connections', on: :member
  end
  


  get '/users/:id/connections', to: 'users#connections', as: 'user_connections'

  get '/pending-requests', to: 'friendships#pending_requests', as: 'pending_requests'
  patch '/friendships/:id/approve', to: 'friendships#approve', as: 'approve_friendship'
  delete '/friendships/:id/reject', to: 'friendships#reject', as: 'reject_friendship'


  
  get '/signup', to:'users#new'
  post '/signup', to:'users#create'






  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end 
