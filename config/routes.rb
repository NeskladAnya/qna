Rails.application.routes.draw do
  devise_for :users

  concern :likeable do
    member do
      post :like
      post :dislike
    end
  end
  
  resources :questions, concerns: [:likeable] do
    resources :answers, shallow: true, only: %i[create update destroy] do
      post :set_best, on: :member
    end
  end

  resources :attachments, only: :destroy

  resources :links, only: :destroy

  resources :rewards, only: %i[index]

  root to: 'questions#index'
end
