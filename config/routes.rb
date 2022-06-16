Rails.application.routes.draw do
  resources :questions do
    resources :answers, shallow: true, except: :new
  end

  root to: 'questions#index'
end
