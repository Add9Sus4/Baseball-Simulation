class PagesController < ApplicationController
  def home
  end

  def about
  end

  def login
  end

  def stats
    @season = Season.last
    render :layout => false
  end

  def draft
    @year = Season.last.year
    @pitchers = Player.where("draft_year = ? AND position = ?", @year, "P")
    @catchers = Player.where("draft_year = ? AND position = ?", @year, "C")
    @first_basemen = Player.where("draft_year = ? AND position = ?", @year, "1B")
    @second_basemen = Player.where("draft_year = ? AND position = ?", @year, "2B")
    @third_basemen = Player.where("draft_year = ? AND position = ?", @year, "3B")
    @shortstops = Player.where("draft_year = ? AND position = ?", @year, "SS")
    @left_fielders = Player.where("draft_year = ? AND position = ?", @year, "LF")
    @center_fielders = Player.where("draft_year = ? AND position = ?", @year, "CF")
    @right_fielders = Player.where("draft_year = ? AND position = ?", @year, "RF")
  end

  def freeAgents
    @pitchers = Player.where("team_id = ? AND position = ? AND retired != ?", 2, "P", 1)
    @catchers = Player.where("team_id = ? AND position = ? AND retired != ?", 2, "C", 1)
    @first_basemen = Player.where("team_id = ? AND position = ? AND retired != ?", 2, "1B", 1)
    @second_basemen = Player.where("team_id = ? AND position = ? AND retired != ?", 2, "2B", 1)
    @third_basemen = Player.where("team_id = ? AND position = ? AND retired != ?", 2, "3B", 1)
    @shortstops = Player.where("team_id = ? AND position = ? AND retired != ?", 2, "SS", 1)
    @left_fielders = Player.where("team_id = ? AND position = ? AND retired != ?", 2, "LF", 1)
    @center_fielders = Player.where("team_id = ? AND position = ? AND retired != ?", 2, "CF", 1)
    @right_fielders = Player.where("team_id = ? AND position = ? AND retired != ?", 2, "RF", 1)
  end

  def leaders
    @seasons = Season.all
    puts 'hello from pages controller!'
    render :layout => false
  end

end
