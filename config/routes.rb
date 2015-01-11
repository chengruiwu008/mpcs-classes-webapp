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

  resources :users do
    collection do
      get   "faculty"
      patch "faculty"
    end
  end

  resources :quarters

  scope "/:year/:season", year: /\d{4}/,
        season: /spring|summer|autumn|winter/ do
    resources :courses
    post "/courses/:id" => "courses#save_bid"
    get "/my_students"  => "users#my_students"
    get "/my_schedule"  => "users#my_schedule"
    get "/my_requests"  => "users#my_requests"
    get "/my_courses"   => "users#my_courses"
  end

  get "/courses" => "courses#global_index", as: :global_courses

end
