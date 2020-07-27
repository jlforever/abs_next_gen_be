Rails.application.routes.draw do
  root 'home#index'

  namespace :api do
    namespace :v1 do
      resources :authentications, only: [:create]
      resources :authentication_renewals, only: [:create]
      resources :courses, only: [:index]
      resources :family_members, only: [:create, :index, :destroy]
      resources :registrations, only: [:create, :index] do
        member do
          get 'class_sessions'
        end
      end
      resources :sign_ups, only: [:create]
      resources :user_profiles, only: [:index]
      resources :user_profile_changes, only: [:create]
    end
  end
end
