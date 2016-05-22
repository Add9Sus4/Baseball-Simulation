class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]

  # GET /games
  # GET /games.json
  def index
    @games = Game.all
  end

  # GET /games/1
  # GET /games/1.json
  def show
  end

  # GET /games/new
  def new
    @game = Game.new
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(game_params)

    # Play game here, then do stuff like @game.home_hits = 7 to update the
    # stats before submitting to the database. This should be done in the model
    @game.play

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url, notice: 'Game was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.require(:game).permit(:home_team_id, :away_team_id, :attendance, :stadium_name, :home_lineup, :away_lineup, :home_atbats, :home_runs_scored, :home_hits, :home_doubles, :home_triples, :home_home_runs, :home_RBI, :home_walks, :home_strikeouts, :home_stolen_bases, :home_caught_stealing, :home_errors, :home_assists, :home_putouts, :home_chances, :away_atbats, :away_runs_scored, :away_hits, :away_doubles, :away_triples, :away_home_runs, :away_RBI, :away_walks, :away_strikeouts, :away_caught_stealing, :away_errors, :away_assists, :away_putouts, :away_chances, :home_pitchers, :away_pitchers, :home_innings_pitched, :home_hits_allowed, :home_runs_allowed, :home_earned_runs_allowed, :home_walks_allowed, :home_strikeouts_recorded, :home_home_runs_allowed, :home_total_pitches, :home_strikes_thrown, :home_balls_thrown, :home_intentional_walks_allowed, :away_innings_pitched, :away_hits_allowed, :away_runs_allowed, :away_earned_runs_allowed, :away_walks_allowed, :away_strikeouts_recorded, :away_home_runs_allowed, :away_total_pitches, :away_strikes_thrown, :away_balls_thrown, :away_intentional_walks_allowed, :player_of_the_game)
    end
end
