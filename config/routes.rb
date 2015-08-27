CourseEnrollment::Application.routes.draw do

  root 'pages#home'

  patch "/users/faculty" => "users#update_faculty", as: :update_faculty
  get "/past_courses" => "courses#global_index", as: :global_courses

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
    get    "/signin"  => "sessions/sessions#new",     as: :new_user_session
    post   "/signin"  => "sessions/sessions#create",  as: :user_session
    delete "/signout" => "sessions/sessions#destroy", as: :destroy_user_session
  end

  scope "/:year/:season", year: /\d{4}-\d{2}/,
        season: /spring|summer|autumn|winter/ do

    get   "/courses/drafts" => "courses#drafts"
    patch "/my_requests"    => "users#update_number_of_courses"
    post  "/my_requests"    => "users#update_requests"
    get   "/my_students"    => "users#my_students"
    get   "/my_schedule"    => "users#my_schedule"
    get   "/my_requests"    => "users#my_requests"
    get   "/my_courses"     => "users#my_courses"

    resources :courses
  end

  resources :academic_years

  resources :quarters

  resources :users do
    collection do
      get "faculty"
    end

    member do
      get "/dashboard" => "users#dashboard"
    end
  end

  get "/students"  => "users#students"
  get "/dashboard" => "users#dashboard"

end
