class PlayersController < ApplicationController
  before_action :set_player, only: [:show, :edit, :update, :destroy]

  # GET /players
  # GET /players.json
  def index
    @players = Player.all
  end

  # GET /players/1
  # GET /players/1.json
  def show
  end

  def showGameLog
    @player = Player.find(params[:id])
    games = Game.where("(home_team_id = ? OR away_team_id = ?) AND attendance > ?", @player.team_id, @player.team_id, 0)
    @player_games = []
    @indices = []
    @atbats = []
    @runs_scored = []
    @hits = []
    @rbi = []
    @home_runs = []
    @walks = []
    @strikeouts = []
    @stolen_bases = []
    @outs_recorded = []
    @hits_allowed = []
    @runs_allowed = []
    @earned_runs_allowed = []
    @walks_allowed = []
    @strikeouts_recorded = []
    @home_runs_allowed = []
    @strikes_thrown = []
    @balls_thrown = []
    @pitching_results = []
    @opponents = []
    games.each do |game|
      game.away_pitchers.split("_").each_with_index do |id, index|
        if @player.id == id.to_i
          @indices.push(index)
          @opponents.push(Team.find(game.home_team_id))
          @player_games.push(game)
          @outs_recorded.push(game.away_outs_recorded.split("_")[index].to_i)
          @hits_allowed.push(game.away_hits_allowed.split("_")[index])
          @runs_allowed.push(game.away_runs_allowed.split("_")[index])
          @earned_runs_allowed.push(game.away_earned_runs_allowed.split("_")[index])
          @walks_allowed.push(game.away_walks_allowed.split("_")[index])
          @strikeouts_recorded.push(game.away_strikeouts_recorded.split("_")[index])
          @home_runs_allowed.push(game.away_home_runs_allowed.split("_")[index])
          @strikes_thrown.push(game.away_strikes_thrown.split("_")[index].to_i)
          @balls_thrown.push(game.away_balls_thrown.split("_")[index].to_i)
          if game.winning_pitcher == @player.id
            @pitching_results.push("W")
          elsif game.losing_pitcher == @player.id
            @pitching_results.push("L")
          else
            @pitching_results.push("-")
          end
        end
      end
      game.home_pitchers.split("_").each_with_index do |id, index|
        if @player.id == id.to_i
          @indices.push(index)
          @opponents.push(Team.find(game.away_team_id))
          @player_games.push(game)
          @outs_recorded.push(game.home_outs_recorded.split("_")[index].to_i)
          @hits_allowed.push(game.home_hits_allowed.split("_")[index])
          @runs_allowed.push(game.home_runs_allowed.split("_")[index])
          @earned_runs_allowed.push(game.home_earned_runs_allowed.split("_")[index])
          @walks_allowed.push(game.home_walks_allowed.split("_")[index])
          @strikeouts_recorded.push(game.home_strikeouts_recorded.split("_")[index])
          @home_runs_allowed.push(game.home_home_runs_allowed.split("_")[index])
          @strikes_thrown.push(game.home_strikes_thrown.split("_")[index].to_i)
          @balls_thrown.push(game.home_balls_thrown.split("_")[index].to_i)
          if game.winning_pitcher == @player.id
            @pitching_results.push("W")
          elsif game.losing_pitcher == @player.id
            @pitching_results.push("L")
          else
            @pitching_results.push("-")
          end
        end
      end
      game.away_lineup.split("_").each_with_index do |id, index|
        if @player.id == id.to_i
          @opponents.push(Team.find(game.home_team_id))
          @player_games.push(game)
          @indices.push(index)
          @atbats.push(game.away_atbats.split("_")[index])
          @runs_scored.push(game.away_runs_scored.split("_")[index])
          @hits.push(game.away_hits.split("_")[index])
          @rbi.push(game.away_RBI.split("_")[index])
          @home_runs.push(game.away_home_runs.split("_")[index])
          @walks.push(game.away_walks.split("_")[index])
          @strikeouts.push(game.away_strikeouts.split("_")[index])
          @stolen_bases.push(game.away_stolen_bases.split("_")[index])
        end
      end
      game.home_lineup.split("_").each_with_index do |id, index|
        if @player.id == id.to_i
          @opponents.push(Team.find(game.away_team_id))
          @player_games.push(game)
          @indices.push(index)
          @atbats.push(game.home_atbats.split("_")[index])
          @runs_scored.push(game.home_runs_scored.split("_")[index])
          @hits.push(game.home_hits.split("_")[index])
          @rbi.push(game.home_RBI.split("_")[index])
          @home_runs.push(game.home_home_runs.split("_")[index])
          @walks.push(game.home_walks.split("_")[index])
          @strikeouts.push(game.home_strikeouts.split("_")[index])
          @stolen_bases.push(game.home_stolen_bases.split("_")[index])
        end
      end
    end
  end

  # GET /players/new
  def new
    @player = Player.new
  end

  # GET /players/1/edit
  def edit
  end

  def showPitchingStats
    @player = Player.find(params[:id])
  end

  def showBattingStats
    @player = Player.find(params[:id])
  end

  def showFieldingStats
    @player = Player.find(params[:id])
  end

  def showTransactions
    @player = Player.find(params[:id])
  end

  def showAchievements
    @player = Player.find(params[:id])
  end

  def showPitchLocations
    @player = Player.find(params[:id])
  end

  # POST /players
  # POST /players.json
  def create
    @player = Player.new(player_params)

    respond_to do |format|
      if @player.save
        flash[:success] = "Player was successfully created."
        format.html { redirect_to @player }
        format.json { render :show, status: :created, location: @player }
      else
        format.html { render :new }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /players/1
  # PATCH/PUT /players/1.json
  def update
    respond_to do |format|
      if @player.update(player_params)
        flash[:success] = "Player was successfully updated."
        format.html { redirect_to @player }
        format.json { render :show, status: :ok, location: @player }
      else
        format.html { render :edit }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /players/1
  # DELETE /players/1.json
  def destroy
    @player.destroy
    respond_to do |format|
      flash[:success] = "Player was successfully destroyed."
      format.html { redirect_to players_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def player_params
      params.require(:player).permit(:team_id, :first_name, :last_name, :age, :height, :weight,
        :position, :salary, :power, :contact, :speed, :patience, :plate_vision, :pull_amount,
        :uppercut_amount, :batting_average, :movement, :control, :location, :agility, :reactionTime,
        :armStrength, :fieldGrounder, :fieldLiner, :fieldFlyball, :fieldPopup, :throwShort, :throwMedium,
        :throwLong, :intelligence, :endurance, :atbats, :hits, :runs, :doubles, :triples, :home_runs,
        :rbi, :walks, :strikeouts, :stolen_bases, :caught_stealing, :errors_committed, :assists, :putouts,
        :chances, :outs_recorded, :hits_allowed, :runs_allowed, :earned_runs_allowed, :walks_allowed,
        :strikeouts_recorded, :home_runs_allowed, :total_pitches, :strikes_thrown, :balls_thrown,
        :intentional_walks_allowed, :current_position, :lineup_position)
    end
end
