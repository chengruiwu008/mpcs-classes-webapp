class ApplicationController < ActionController::Base

  # For q_link_to, q_path, and q_url
  include ApplicationHelper

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

  def redirect_if_wrong_quarter_params(obj)
    y = obj.quarter.year
    s = obj.quarter.season
    if params[:year].to_i != y or params[:season] != s
      redirect_to q_path(obj) and return
    end
  end

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
  end

  def is_admin?
    message = "Access denied."
    redirect_to root_url, flash: { error: message } and return unless
      current_user.admin?
  end

  def get_this_user_for_object(obj)
    obj.this_user = current_user
  end

  def get_quarter
    @quarter = Quarter.find_by(year: year_unslug(params[:year]),
                               season: params[:season])
  end

  def get_num_courses_arr
    quarter = Quarter.find_by(year: year_unslug(params[:year]),
                              season: params[:season])
    @num_courses_arr = ["No preference"]
    @num_courses_arr += (1..Course.where(quarter_id: quarter.id).count).to_a
  end

end
