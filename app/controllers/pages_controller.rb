class PagesController < ApplicationController

  before_action :authenticate_user!, except: :home

  def home
    unless Quarter.active_quarter
      flash[:error] = "An administrator must create an active quarter."
      render 'home' and return
    end

    y = Quarter.active_quarter.year
    s = Quarter.active_quarter.season
    redirect_to controller: :courses, action: :index, year: y, season: s
  end

end
