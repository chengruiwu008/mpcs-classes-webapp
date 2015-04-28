class PagesController < ApplicationController

  before_action :authenticate_user!, except: :home

  def home
    y = Quarter.active_quarter.year
    s = Quarter.active_quarter.season
    redirect_to controller: :courses, action: :index, year: y, season: s
  end

end
