require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
      end

      resources :questions, only: %i[index show create update destroy] do
        resources :answers, only: %i[index show create update destroy], shallow: true
      end

      resources :users, only: [:index]
    end
  end

  concern :likeable do
    member do
      post :like
      post :dislike
    end
  end

  concern :commentable do
    member do
      post :create_comment
    end
  end
  
  resources :questions, concerns: %i[likeable commentable] do
    resources :answers, shallow: true, only: %i[create update destroy], concerns: %i[likeable commentable] do
      post :set_best, on: :member
    end
  end

  resources :attachments, only: :destroy

  resources :links, only: :destroy

  resources :rewards, only: %i[index]

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
