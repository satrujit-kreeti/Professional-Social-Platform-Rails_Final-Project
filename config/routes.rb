Rails.application.routes.draw do
  get '/auth/linkedin/callback', to: 'sessions#linkedin', as: 'linkedin'

  root 'sessions#new'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/home', to: 'users#home'

  get '/users/details/:id', to: 'users#edit', as: 'edit_user'
  patch '/users/details/:id', to: 'users#update'

  # delete '/users/:id/delete_account', to: 'users#delete_account', as: 'delete_account'
  match '/users/:id/delete_account', to: 'users#delete_account', via: %i[delete get], as: 'delete_account'

  get '/profile', to: 'users#profile'

  get '/home/:id/profiles', to: 'users#profiles', as: 'user_profile'

  resources :users do
    member do
      post 'report'
      get 'edit_password'
      patch 'update_password'
      get 'connect', to: 'users#connect'
      post 'connect', to: 'users#connect'
      match 'disconnect', to: 'users#disconnect', via: %i[delete get post]
    end
    get 'connections', on: :member
  end

  resources :users do
    resources :posts, only: %i[new create]
  end

  resources :posts, only: [:show] do
    resources :comments, only: %i[new create]
  end

  resources :posts do
    resources :likes, only: %i[create index]
  end

  get '/users/:id/connections', to: 'users#connections', as: 'user_connections'

  get '/pending-requests', to: 'friendships#pending_requests', as: 'pending_requests'
  patch '/friendships/:id/approve', to: 'friendships#approve', as: 'approve_friendship'
  delete '/friendships/:id/reject', to: 'friendships#reject', as: 'reject_friendship'

  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  get 'users_list', to: 'users#users_list', as: 'users_list'

  namespace :admin do
    resources :job_sectors do
      get 'job_roles', on: :member, defaults: { format: :json }
    end
    resources :job_roles
  end

  post '/admin/job_sectors/increment_number', to: 'admin/job_sectors#increment_number', as: 'increment_number'

  resources :job_requirements do
    member do
      patch :approve
      patch :reject
    end
  end

  get '/my_jobs', to: 'job_requirements#my_jobs', as: 'my_jobs'
  post 'job_requirements/:id/apply', to: 'job_requirements#apply', as: 'apply_job_requirements'

  resources :job_requirements do
    resources :job_comments, only: %i[new create]
  end

  resources :users do
    collection do
      get 'search', to: 'users#search'
    end
  end

  resources :conversations, only: %i[index show create new] do
    resources :messages, only: [:create]
  end

  mount ActionCable.server => '/cable'

  patch '/mark_all_as_read', to: 'notifications#mark_all_as_read', as: 'mark_all_as_read'
  resources :certificates, only: [:destroy]

  resources :job_profiles do
    member do
      get 'toggle_edit'
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
