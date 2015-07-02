class QuartersController < ApplicationController

  include QuarterPatterns

  load_and_authorize_resource

  before_action :downcase_season,      only: :create
  before_action :is_admin?,            only: [:new, :create]
  before_action :quarter_has_courses?, only: :destroy
  before_action :all_fields_present?,  only: [:create, :update]
  before_action :get_year_and_season,  only: [:edit, :update]
  # FIXME: it looks like the error is occuring because of the lack of the deadlines, not because
  # of the year becoming nil (at least, not anymore; but i can try adding the binding.pry back
  # in to see what's wrong).

  # also, try starting from a fresh test database and creating the years and then the quarters.

  # we're getting stopped by the all_fields_present? before filter, but
  # this renders 'new', which renders the view without calling the
  # get_years_form_hash before filter. so we'll instead add a method
  # to the academic_year model that grabs the same hash that
  # get_years_form_hash was getting for us.


  def index
  end

  def show

  end

  def new
    # A bit sloppy.
    # This hash is sent to the client and used to pre-populate the form
    # fields with dates in a format that Rails likes.
    @deadlines = {
      start:  l(view_context.start_date, format: :twb),
      course: l(view_context.default_deadline("course"), format: :twb),
      bid:    l(view_context.default_deadline("bid"), format: :twb),
      end:    l(view_context.end_date, format: :twb) }
    @deadlines.to_json
  end

  def create
    save :new
  end

  def edit
  end

  def update
    save :edit
  end

  def destroy
    @quarter.active? ? (redirect_to quarters_path and return) : (save :index)
  end

  private

  def quarter_params
    params.require(:quarter).permit(:season, :year, :current,
                                    :course_submission_deadline,
                                    :student_bidding_deadline,
                                    :start_date, :end_date, :published)
  end

  def downcase_season
    @quarter.season.downcase!
  end

  def quarter_has_courses?
    if @quarter.courses.count > 0
      flash[:error] = "Courses have already been made in this quarter, " +
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
