Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :authentications, only: [:create]
      resources :authentication_renewals, only: [:create]
      resources :sign_ups, only: [:create]
      resources :user_profiles, only: [:index, :update]
    end
  end
end
