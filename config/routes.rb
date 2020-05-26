Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :authentications, only: [:create]
      resources :authentication_renewals, only: [:create]
      resources :family_members, only: [:create, :index, :destroy]
      resources :sign_ups, only: [:create]
      resources :user_profiles, only: [:index]
      resources :user_profile_changes, only: [:create]
    end
  end
end
