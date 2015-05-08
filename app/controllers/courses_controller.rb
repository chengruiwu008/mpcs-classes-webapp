class CoursesController < ApplicationController

  include CoursePatterns

  load_and_authorize_resource find_by: :number

  before_action :authenticate_user!, except: [:global_index, :show]

  before_action :get_quarter,            only: [:show, :index, :drafts]
  before_action :get_year_and_season,    only: [:create, :update]
  before_action :get_courses_in_qrtr,    only: [:index, :drafts]
  before_action :get_num_courses_arr,    only: :show
  before_action :get_bid,                only: :show
  before_action :get_db_course,          only: [:edit, :update]
  before_action :get_db_instructor_cnet, only: [:edit, :update]
  before_action :get_instructors,        only: [:new, :create, :edit, :update]
  before_action :get_instructor,         only: [:create, :update]

  before_action(only: [:show, :edit]) { |c|
    c.redirect_if_wrong_quarter_params(@course) }

  def show
  end

  def global_index
    y = params[:year]
    s = params[:season].try(:downcase)
    active = Quarter.active_quarter
    @quarter = y && s ? Quarter.find_by(year: y, season: s) : active
    @courses = @quarter ? @quarter.courses : []
  end

  def index
    @courses = @courses.where(draft: false)
  end

  def drafts
    @courses = @courses.where(draft: true)
  end

  def new
  end

  def create
    # TODO: Use a symbol other than :instructor_id here and in #update?
    params[:course][:instructor_id] = @instructor.id
    @course = @instructor.courses.build(course_params)
    @quarter = Quarter.find_by(year: params[:year], season: params[:season])
    @course.assign_attributes(quarter_id: @quarter.id,
                              instructor_id: @instructor.id)

    save 'new'
  end

  def edit
  end

  def update
    params[:course][:instructor_id] = @instructor.id if @instructor

    if @course.draft?
      @course.assign_attributes(course_params)
      save 'edit'
    else
      if @course.update_attributes(course_params)
        flash[:success] = "Course information successfully updated."
        redirect_to q_path(@course)
      else
        render 'edit'
      end
    end
  end

  private

  def course_params
    params.require(:course).permit(:title, :instructor_id, :syllabus,
                                   :number, :prerequisites, :time, :location)
  end

  def get_year_and_season
    @year   = params[:year]
    @season = params[:season]
  end

  def get_courses_in_qrtr
    @courses = Course.where(quarter_id: @quarter.id)
  end

  def get_bid
    if current_user.try(:student?)
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

  def get_db_instructor_cnet
    @db_instructor_cnet = Faculty.find(@course.instructor_id).cnet
  end

  def get_instructors
    @instructors = Faculty.all.map { |f| [f.full_name, f.cnet] }
  end

  def get_instructor
    # @instructor is nil if a faculty member is editing their course
    @instructor = Faculty.find_by(cnet: params[:course][:instructor_id])
  end

end
