class CoursesController < ApplicationController

  load_and_authorize_resource find_by: :number

  before_action :get_quarter,         only: [:show, :save_bid, :index]
  before_action :get_year_and_season, only: [:create, :update]
  before_action :get_courses_in_qrtr, only: :index
  before_action :get_num_courses_arr, only: :show
  before_action :get_bid,             only: [:show, :save_bid]
  before_action :get_db_course,       only: [:edit, :update]

  before_action(only: [:show, :edit]) { |c|
    c.redirect_if_wrong_quarter_params(@course) }

  def show
  end

  def index
    @courses = @courses.where(draft: false)
  end

  def new
  end

  # TODO: Abstract duplicated code out of #create and #update
  def create
    @course = current_user.courses.build(course_params)
    @quarter = Quarter.find_by(year: params[:year], season: params[:season])
    @course.assign_attributes(quarter_id: @quarter.id)

    if params[:commit] == "Create this course"
      if @course.save
        flash[:success] = "Course submitted."
        redirect_to my_courses_path(year: @year, season: @season)
      else
        render 'new'
      end
    elsif params[:commit] == "Save as draft"
      @course.assign_attributes(draft: true)
      if @course.save
        flash[:success] = "Course information saved. You may edit it " +
          "by navigating to your \"my courses\" page."
        redirect_to my_courses_path(year: @year, season: @season)
      else
        render 'new'
      end
    end

  end

  def edit
  end

  def update
    if @course.draft?
      @course.assign_attributes(course_params)

      if params[:commit] == "Create this course"
        @course.assign_attributes(draft: false)
        if @course.save
          flash[:success] = "Course submitted."
          redirect_to my_courses_path(year: @year, season: @season)
        else
          render 'edit'
        end

      elsif params[:commit] == "Save as draft"
        if @course.save
          flash[:success] = "Course information saved. You may edit it " +
            "by navigating to your \"my courses\" page."
          redirect_to my_courses_path(year: @year, season: @season)
        else
          render 'edit'
        end
      end

    else
      if @course.update_attributes(course_params)
        flash[:success] = "Course information successfully updated."
        redirect_to q_path(@course)
      else
        render 'edit'
      end
    end
  end

  def save_bid
    bps = bid_params

    if bps[:preference] == "No preference" # Destroy the bid

      if @bid.destroy
        flash[:success] = "Successfully updated course preference."
        redirect_to q_path(@course) and return
      end

    else # Create or update the bid

      if @bid.new_record?
        bps.merge!(quarter_id: @quarter.id, course_id: @course.id)
      end

      if @bid.update_attributes(bps)
        Bid.update_preferences(@bid)
        flash[:success] = "Successfully updated course preference."
        redirect_to q_path(@course) and return
      else
        flash[:error].now = "Unable to update course request."
        render 'show' and return
      end
    end
  end

  private

  def course_params
    params.require(:course).permit(:title, :syllabus, :number,
                                    :prerequisites, :time, :location)
  end

  def bid_params
    params.require(:bid).permit(:preference)
  end

  def get_year_and_season
    @year   = params[:year]
    @season = params[:season]
  end

  def get_courses_in_qrtr
    @courses = Course.where(quarter_id: @quarter.id)
  end

  def get_bid
    if current_user.student?
      @bid = Bid.find_by(course_id: @course.id,
                         student_id: current_user.id) || current_user.bids.new
    end
  end

  def get_db_course
    # We use the course from the database so that we don't try to update the
    # wrong course if the instructor first tries to save an invalid course
    # (e.g., by changing the number or title to another course's) and then
    # corrects their mistake.
    @db_course = Course.find(@course.id)
  end

end
