class CoursesController < ApplicationController

  load_and_authorize_resource

  before_action :get_year_and_season, only: [:create, :update]

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

  private

  def course_params
    params.require(:course).permit(:title, :syllabus, :number,
                                    :prerequisites, :time, :location)
  end

  def get_year_and_season
    @year   = params[:year]
    @season = params[:season]
  end

end
