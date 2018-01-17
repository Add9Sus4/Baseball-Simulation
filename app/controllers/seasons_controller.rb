class SeasonsController < ApplicationController

  def index
    @seasons = Season.first(Season.count - 1)
  end

  def show
    puts "show method called from Seasons Controller with id=#{params[:id]}!"
    @season = Season.find(params[:id])
    render :layout => false
  end

  def currentSeason
    @season = Season.last
  end

end
