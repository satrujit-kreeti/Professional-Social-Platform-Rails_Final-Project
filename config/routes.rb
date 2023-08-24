# rubocop:disable all

Rails.application.routes.draw do

  mount ActionCable.server => '/cable'
  
  get '/auth/linkedin/callback', to: 'sessions#linkedin', as: 'linkedin'

  root 'sessions#new'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'


  match '/users/:id/delete_account', to: 'users#delete_account', via: %i[delete get], as: 'delete_account'
  patch '/mark_all_as_read', to: 'notifications#mark_all_as_read', as: 'mark_all_as_read'


  resources :users, shallow: true, path: '' do
    member do
      post 'report'
      patch 'update_password'
      get 'connect', to: 'users#connect'
      post 'connect', to: 'users#connect'
      match 'disconnect', to: 'users#disconnect', via: %i[delete get post]
      delete :remove_cv
      get :edit
      patch :update
      get :profiles, as: 'user_profile'
    end
    collection do
      get :profile
      get :connections, as: 'user_connections'
      get :edit_password
      get :home
      get :users_list
      get :search

      resources :certificates, only: [:destroy]

      resources :posts, shallow: true do
        member do
          post :approve
          post :reject
        end
        collection  do
          get :my_posts
        end
        resources :comments, only: %i[new create]
        resources :likes, only: %i[create index]
      end

      resources :friendships, shallow: true, path: '', only: %i[] do
        collection do
          get :pending_requests
        end
        member do
          patch :approve
          delete :reject
        end
      end

      resources :job_requirements do
        member do
          patch :approve
          patch :reject
          post :apply
        end
        collection do
          get :my_jobs
        end
        resources :job_comments, only: %i[new create]
      end

      resources :conversations, only: %i[index show create new] do
        resources :messages, only: [:create]
      end

      resources :job_profiles do
        member do
          get 'toggle_edit'
        end
      end
    end
  end

  namespace :admin do
    resources :job_sectors do
      get 'job_roles', on: :member, defaults: { format: :json }
    end
    resources :job_roles
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
