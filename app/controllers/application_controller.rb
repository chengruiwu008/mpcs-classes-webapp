class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    redirect_to root_url, alert: "Access denied: #{exception}"
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, flash: { error: "Access denied: #{exception}" }
  end

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :is_admin?
  helper_method :authenticate_user!
  helper_method :current_user

  # def authenticate_user!
  #   if student_signed_in?
  #     authenticate_student!
  #   elsif faculty_signed_in?
  #     authenticate_faculty!
  #   elsif admin_signed_in?
  #     authenticate_admin!
  #   end
  # end

  # def current_user
  #   current_student or current_faculty or current_admin
  # end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) do |user|
      if current_user.admin?
        user.permit(:admin, :faculty, :student, :affiliation, :department)
      elsif current_user.advisor?
        user.permit(:affiliation, :department)
      end
    end

    devise_parameter_sanitizer.for(:sign_in) do |user|
      user.permit(:cnet, :email, :password)
    end

    # devise_parameter_sanitizer.for(:sign_up) do |user|
    #   user.permit(:email, :password, :password_confirmation,
    #               :first_name, :last_name, :affiliation, :department)
    # end
  end

  def is_admin?
    message = "Access denied."
    redirect_to root_url, flash: { error: message } and return unless
      current_user.admin?
  end

  # def before_deadline?(d)
  #   humanized_deadline = d.humanize.downcase

  #   e = Quarter.active_exists?
  #   b = Quarter.active_quarters.map { |q| DateTime.now <= q.deadline(d) }.all?
  #   message = "The #{humanized_deadline} deadline for this quarter has passed."
  #   redirect_to root_url, flash: { error: message } unless (b and e)
  # end

end
