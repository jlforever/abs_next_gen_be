Rails.application.routes.draw do
  root 'home#index'

  namespace :api do
    namespace :v1 do
      resources :authentications, only: [:create]
      resources :authentication_renewals, only: [:create]
      resources :courses, only: [:index] do
        member do
          get 'teaching_sessions'
        end
      end
      resources :class_sessions, only: [:show]
      resources :family_members, only: [:create, :index, :destroy]
      resources :password_reset_requests, only: [:create]
      resources :password_resets, param: :reset_token, constraints: { reset_token: /[\-\d\w]+/ }, only: [:edit, :update]
      resources :registrations, only: [:create, :index] do
        member do
          get 'class_sessions'
        end
      end
      resources :sign_ups, only: [:create]
      resources :teaching_sessions, only: [] do
        member do
          post 'student_materials'
        end
      end
      resources :user_profiles, only: [:index]
      resources :user_profile_changes, only: [:create]
    end
  end
end
