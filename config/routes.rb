CourseEnrollment::Application.routes.draw do

  devise_for :users, skip: [:sessions, :registrations]

  # For logging in
  devise_scope :ldap_user do
    get "/signin" => "sessions/sessions#new", as: :new_user_session
    post "/signin" => "sessions/sessions#create", as: :user_session
    delete "/signout" => "sessions/sessions#destroy", as: :destroy_user_session

    # Prevent users from deleting their own accounts.
    resource :registration,
    only: [:new, :create, :edit, :update],
    controller: "devise/registrations",
    as: :user_registration do
      get :cancel
    end
  end

  root 'pages#home'
end
