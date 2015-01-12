class UsersController < ApplicationController

  load_and_authorize_resource

  before_action :get_quarter,           only: [:my_courses, :my_requests]
  before_action :is_admin?,             only: :index
  before_action :prevent_self_demotion, only: :update
  before_action :get_user,              only: [:my_courses, :my_bids,
                                               :my_students, :my_requests,
                                               :update_number_of_courses]
  before_action :get_my_courses,        only: :my_courses
  before_action :get_all_my_courses,    only: :my_courses_all
  before_action :get_my_bids,           only: :my_requests
  before_action :get_all_my_bids,       only: :my_requests_all
  before_action :get_courses_bids,      only: :my_requests
  before_action :get_number_of_courses, only: :my_requests
  before_action(only: :update) { |c| c.get_this_user_for_object(@user) }

  def show
  end

  def index
    @users = User.all.page(params[:page])
  end

  def faculty
    @users = User.all.where(type: "Faculty")
  end

  def edit
  end

  def update_number_of_courses
    if @user.update_attributes(user_params)
      flash[:success] = "Changed desired number of courses."
      redirect_to my_requests_path(year: params[:year],
                                   season: params[:season])
    else
      render 'my_requests'
    end
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Settings successfully updated."
      redirect_to @user
    else
      render 'show'
    end
  end

  # Quarter-specific
  def my_courses
  end

  # Quarter-specific
  def my_requests
  end

  # Quarter-specific
  def my_students
    q  = Quarter.where(year: params[:year], season: params[:season]).take
    @students = @user.students_and_submissions_in_quarter(q)
  end

  # All of this user's projects
  def my_projects_all
  end

  # All of this user's applications
  def my_submissions_all
  end

  private

  def user_params
    as = []

    if current_user.admin?
      as = [:type, :affiliation, :department, :number_of_courses]
    elsif current_user.faculty?
      as = [:affiliation, :department]
    elsif current_user.student?
      as = [:number_of_courses]
    end

    params.require(:user).permit(as)
  end

  def prevent_self_demotion
    if params[:id].to_i == current_user.id and
        params[:user][:admin]              and
        params[:user][:admin].to_i == 0    and
        current_user.admin?
      message = "You cannot demote yourself."
      redirect_to @user, flash: { error: message }
    end
  end

  def get_user
    @user = current_user
  end

  def get_my_courses
    @courses = Course.where(instructor_id: @user.id, quarter_id: @quarter.id)
  end

  def get_all_my_courses
    @courses = Course.where(instructor_id: @user.id)
  end

  def get_my_bids
    @bids = Bid.quarter_bids(@quarter).where(student_id: @user.id)
  end

  def get_all_my_bids
    @bids = Bid.where(student_id: @user.id)
  end

  def get_courses_bids
    cs = Course.where(quarter_id: @quarter.id)
    @courses_bids = {}

    cs.each do |c|
      @courses_bids[c] = Bid.find_by(student_id: @user.id, course_id: c.id)
    end

    # TOOD: pass a user_id param if an admin is viewing this user's page,
    # instead of using @user.id?
  end

  def get_number_of_courses
    @possible_num_courses = (1..User::MAX_COURSES)
  end

end
