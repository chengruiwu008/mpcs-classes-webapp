class PagesController < ApplicationController

  before_action :authenticate_user!, except: :home

  def home
    render 'courses/index'
  end

end
