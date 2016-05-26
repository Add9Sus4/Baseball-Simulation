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

  # GET /players/new
  def new
    @player = Player.new
  end

  # GET /players/1/edit
  def edit
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
      params.require(:player).permit(:team_id, :first_name, :last_name, :age, :height, :weight, :position, :salary, :power, :contact, :speed, :patience, :plate_vision, :pull_amount, :uppercut_amount, :batting_average, :movement, :control, :location, :agility, :reactionTime, :armStrength, :fieldGrounder, :fieldLiner, :fieldFlyball, :fieldPopup, :throwShort, :throwMedium, :throwLong, :intelligence, :endurance, :atbats, :hits, :runs, :doubles, :triples, :home_runs, :rbi, :walks, :strikeouts, :stolen_bases, :caught_stealing, :errors_committed, :assists, :putouts, :chances, :outs_recorded, :hits_allowed, :runs_allowed, :earned_runs_allowed, :walks_allowed, :strikeouts_recorded, :home_runs_allowed, :total_pitches, :strikes_thrown, :balls_thrown, :intentional_walks_allowed)
    end
end
