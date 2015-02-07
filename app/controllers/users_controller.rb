class UsersController < ApplicationController

  load_and_authorize_resource

  before_action :get_quarter,           only: [:my_courses, :my_requests,
                                               :update_requests]
  before_action :is_admin?,             only: :index
  before_action :prevent_self_demotion, only: :update
  before_action :get_user,              only: [:my_courses, :my_bids,
                                               :my_students, :my_requests,
                                               :update_number_of_courses,
                                               :update_requests]
  before_action :get_my_courses,        only: :my_courses
  before_action :get_all_my_courses,    only: :my_courses_all
  before_action :get_my_bids,           only: :my_requests
  before_action :get_all_my_bids,       only: :my_requests_all
  before_action :get_courses_bids,      only: :my_requests
  before_action :get_number_of_courses, only: :my_requests
  before_action :get_num_courses_arr,   only: [:my_requests, :update_requests]
  before_action(only: :update) { |c| c.get_this_user_for_object(@user) }

  def show
  end

  def index
    @users = User.all.page(params[:page])
  end

  def faculty
    @users = User.all.where(type: "Faculty").page(params[:page])
  end

  def update_faculty
    if params[:faculty_cnet].length > 0
      @faculty = User.find_by(cnet: params[:faculty_cnet])

      if @faculty
        saved = @faculty.update_attributes(type: "Faculty")
      else
        saved = User.create(cnet: params[:faculty_cnet], type: "Faculty")
      end
    else
      saved = true
    end
    # TODO: Make `saved` depend on the success of faculty_to_students (?)
    User.faculty_to_students(params[:remove]) if params[:remove]

    if saved
      flash[:success] = "Successfully updated the list of instructors.."
      redirect_to faculty_users_path
    else
      flash[:error] = "Unable to update the list of instructors."
      render 'faculty'
    end
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

  def update_requests
    @prefs = params[:preferences].values.reject { |p| p == "No preference" }

    if @prefs == @prefs.uniq # No duplicate ranks
      @user.update_bids(params[:preferences], @quarter)
      flash[:success] = "Updated preferences."
    else
      flash[:error] = "Each course must have a unique rank."
    end

    redirect_to my_requests_path(year: params[:year],
                                 season: params[:season]) and return
  end

  private

  def user_params
    as = []

    if current_user.admin?
      as = [:type, :affiliation, :department, :number_of_courses, :faculty_cnet]
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

    # TODO: Sort the course_bids by preference, using something like
    # @course_bids = @course_bids.sort_by { |k, v| v.try(:preference) || 0 }
    cs.each do |c|
      @courses_bids[c] = Bid.find_by(student_id: @user.id, course_id: c.id)
    end
  end

  def get_number_of_courses
    @possible_num_courses = (1..User::MAX_COURSES)
  end

end
