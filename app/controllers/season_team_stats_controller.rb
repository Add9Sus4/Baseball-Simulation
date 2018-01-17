class SeasonTeamStatsController < ApplicationController
  before_action :set_season_team_stat, only: [:show, :edit, :update, :destroy]

  # GET /season_team_stats
  # GET /season_team_stats.json
  def index
    @season_team_stats = SeasonTeamStat.all
  end

  # GET /season_team_stats/1
  # GET /season_team_stats/1.json
  def show
    @season = Season.find(params[:id])
    @teams = SeasonTeamStat.where("season_id = ?", @season.id)
    render :layout => false
  end

  # GET /season_team_stats/new
  def new
    @season_team_stat = SeasonTeamStat.new
  end

  # GET /season_team_stats/1/edit
  def edit
  end

  # POST /season_team_stats
  # POST /season_team_stats.json
  def create
    @season_team_stat = SeasonTeamStat.new(season_team_stat_params)

    respond_to do |format|
      if @season_team_stat.save
        format.html { redirect_to @season_team_stat, notice: 'Season team stat was successfully created.' }
        format.json { render :show, status: :created, location: @season_team_stat }
      else
        format.html { render :new }
        format.json { render json: @season_team_stat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /season_team_stats/1
  # PATCH/PUT /season_team_stats/1.json
  def update
    respond_to do |format|
      if @season_team_stat.update(season_team_stat_params)
        format.html { redirect_to @season_team_stat, notice: 'Season team stat was successfully updated.' }
        format.json { render :show, status: :ok, location: @season_team_stat }
      else
        format.html { render :edit }
        format.json { render json: @season_team_stat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /season_team_stats/1
  # DELETE /season_team_stats/1.json
  def destroy
    @season_team_stat.destroy
    respond_to do |format|
      format.html { redirect_to season_team_stats_url, notice: 'Season team stat was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_season_team_stat
      @season_team_stat = SeasonTeamStat.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def season_team_stat_params
      params.fetch(:season_team_stat, {})
    end
end
