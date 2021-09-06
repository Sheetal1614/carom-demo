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

  root to: 'sessions#index'
end
