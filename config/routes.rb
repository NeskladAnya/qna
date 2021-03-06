Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, shallow: true, only: %i[create update destroy] do
      post :set_best, on: :member
    end
  end

  resources :attachments, only: :destroy

  root to: 'questions#index'
end
