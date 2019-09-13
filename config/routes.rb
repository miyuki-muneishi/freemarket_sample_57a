Rails.application.routes.draw do
  devise_for :users, controllers:{
    sessions: 'users/sessions',
  }

  resources  :users, only: [:show, :destroy]
  resources  :items do
    collection do
      get 'get_category_children', defaults: { format: 'json' }
      get 'get_category_grandchildren', defaults: { format: 'json' }
    end
  end
  resources  :buys, only: [:index, :show]
  resources  :categories, only: [:show]
  root 'items#index'


  resources :signup do
    collection do
      get  '/'               => 'signup#new'
      get  'step1'           => 'signup#step1'
      get  'step2'           => 'signup#step2'
      get  'step3'           => 'signup#step3'
      get  'step4'           => 'signup#step4'
      post 'signup/create'   => 'signup#create'
      get  'step5'           => 'signup#step5'
    end
  end

  get 'identification' => 'users#identification'
  get 'card_registration' => 'buys#card_registration'
end

# registrations: 'users/registrations' ,
# omniauth_callbacks: 'users/omniauth_callbacks'

# get "/auth/:provider/callback" => 'sessions#createByFacebook'
# get "/auth/:provider/callback" => 'google#callback'