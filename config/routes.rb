Rails.application.routes.draw do
  devise_for :users

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
