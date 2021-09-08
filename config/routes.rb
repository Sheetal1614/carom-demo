Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  post '/test_callback', to: 'documents#test_callback'

  get '/sign-up', to: 'sessions#sign_up', as: 'sign_up'
  post '/sign-up', to: 'sessions#sign_up'

  resource :session, only: [:create, :destroy] do
    collection do
      get :login

      get :okta_login
      post :okta_login

      post :renew_fennel_access_token
    end
  end

  resources :accounts, only: [:index, :create, :show] do
    resources :pokes, only: [:new, :create]
  end

  resources :pokes, only: [:update, :destroy]

  resources :documents, only: [:index]

  resources :teams, only: [] do
    member do
      get :members
      post :members

      get :accounts
      post :toggle_team_leader
      delete :remove_member
    end
  end

  get 'under_grounds', to: 'under_grounds#accounts'
  resources :under_grounds, only: [] do
    collection do
      get :accounts
      get :teams
      get :application_admins
      get :miscellaneous

      post :account
      post :teams
      post :application_admins
      post :miscellaneous

      delete :application_admins
    end
  end

  resources :enumerations, only: [], constraints: lambda {|req| req.format == :json} do
    collection do
      get :people
    end
  end

  root to: 'sessions#index'
end
