CourseEnrollment::Application.routes.draw do

  root 'pages#home'

  devise_for :users, skip: [:sessions, :registrations]

  # For logging in
  devise_scope :user do
    get "/signin" => "sessions/sessions#new", as: :new_user_session
    post "/signin" => "sessions/sessions#create", as: :user_session
    delete "/signout" => "sessions/sessions#destroy", as: :destroy_user_session
  end

  resources :users

end
