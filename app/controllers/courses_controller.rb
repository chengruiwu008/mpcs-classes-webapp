class CoursesController < ApplicationController

  load_and_authorize_resource find_by: :number

  before_action :get_quarter,         only: [:show, :save_bid, :index]
  before_action :get_year_and_season, only: [:create, :update]
  before_action :get_courses_in_qrtr, only: :index
  before_action :get_num_courses_arr, only: :show
  before_action :get_bid,             only: [:show, :save_bid]


  def show
  end

  def index
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
      if @course.save(validate: false)
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
        if @course.save(validate: false)
          flash[:success] = "Course information saved. You may edit it " +
            "by navigating to your \"my courses\" page."
          redirect_to my_courses_path(year: @year, season: @season)
        end
      end

    else
      if @course.update_attributes(course_params)
        flash[:success] = "Course information successfully updated."
        redirect_to q_path(@course)
      end
    end
  end

  def save_bid
    bps = bid_params

    if @bid.new_record?
      bps.merge!(quarter_id: @quarter.id, course_id: @course.id)
    end

    if @bid.update_attributes(bps)
      flash[:success] = "Successfully updated course preference."
      redirect_to q_path(@course) and return
    else
      flash[:error].now = "Unable to update course request."
      render 'show' and return
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

  def get_num_courses_arr
    @num_courses_arr = ["No preference"]
    @num_courses_arr += (1..Course.where(quarter_id: @quarter.id).count).to_a
  end

  def get_bid
    @bid = Bid.find_by(course_id: @course.id,
                       student_id: current_user.id) || current_user.bids.new
  end

  def get_quarter
    @quarter = Quarter.find_by(year: params[:year], season: params[:season])
  end

end
