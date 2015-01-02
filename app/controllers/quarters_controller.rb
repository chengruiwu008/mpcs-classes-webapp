class QuartersController < ApplicationController

  load_and_authorize_resource

  before_action :downcase_season,              only: :create
  before_action :is_admin?,                    only: [:new, :create]
  before_action :quarter_belongs_to_projects?, only: :destroy
  before_action :all_fields_present?,          only: [:create, :update]
  before_action :get_year_and_season,          only: [:edit, :update]

  def index
  end

  def show
    @quarter_projects = Project.quarter_accepted_projects(@quarter)
  end

  def new
    # A bit sloppy.
    # This hash is sent to the client and used to pre-populate the form
    # fields with dates in a format that Rails likes.
    @deadlines = {
      start:      l(view_context.start_date, format: :twb),
      course:   l(view_context.default_deadline("course"), format: :twb),
      bid: l(view_context.default_deadline("bid"), format: :twb),
      end:        l(view_context.end_date, format: :twb) }
    @deadlines.to_json
  end

  def create
    if @quarter.update_attributes(quarter_params)
      flash[:success] = "Quarter successfully created."
      redirect_to quarters_path
    else
      flash.now[:error] = "Quarter could not be created."
      render 'new'
    end
  end

  def edit
  end

  def update
    if @quarter.update_attributes(quarter_params)
      flash[:success] = "Quarter successfully updated."
      redirect_to quarters_path
    else
      flash.now[:error] = "Failed to update the quarter."
      render 'edit'
    end
  end

  def destroy
    redirect_to quarters_path and return if @quarter.current?
    if @quarter.destroy
      flash[:success] = "Quarter successfully deleted."
      redirect_to quarters_path and return
    else
      flash.now[:error] = "Failed to delete the quarter."
      render 'index'
    end
  end

  private

  def quarter_params
    params.require(:quarter).permit(:season, :year, :current,
                                    :course_submission_deadline,
                                    :student_bidding_deadline,
                                    :start_date, :end_date)
  end

  def downcase_season
    @quarter.season.downcase!
  end

  def quarter_belongs_to_projects?
    if @quarter.projects.count > 0
      flash[:error] = "Projects have already been made in this quarter, "\
      "so you cannot delete it."
      redirect_to quarters_path and return
    end
  end

  def all_fields_present?
    unless (@quarter.start_date.present? and
            @quarter.course_submission_deadline.present? and
            @quarter.student_bidding_deadline.present? and
            @quarter.end_date.present?)
      flash.now[:error] = "You must enter each date and deadline."
        render 'new'
    end
  end

  def get_year_and_season
    @year   = @quarter.year
    @season = @quarter.season
  end

end
