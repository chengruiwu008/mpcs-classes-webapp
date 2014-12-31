CourseEnrollment::Application.routes.draw do

  root 'pages#home'

  # The :users line is necessary.
  devise_for :users, skip: [:sessions, :registrations], controllers:
    { sessions: 'sessions' }
  devise_for :students, skip: [:sessions, :registrations], controllers:
    { sessions: 'sessions' }
  devise_for :faculties, skip: [:sessions, :registrations], controllers:
    { sessions: 'sessions' }
  devise_for :admins, skip: [:sessions, :registrations], controllers:
    { sessions: 'sessions' }

  # For logging in
  devise_scope :user do
    get "/signin" => "sessions/sessions#new", as: :new_user_session
    post "/signin" => "sessions/sessions#create", as: :user_session
    delete "/signout" => "sessions/sessions#destroy", as: :destroy_user_session
  end

  resources :users

end
