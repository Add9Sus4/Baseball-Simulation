class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  # GET /teams
  # GET /teams.json
  def index
    @teams = Team.all
  end

  def edit_position
    @team = Team.find(params[:id])
  end

  def batters
    @team = Team.find(params[:id])
  end

  def pitchers
    @team = Team.find(params[:id])
  end

  def editPitching
    @team = Team.find(params[:id])
  end

  def editPositions
    @team = Team.find(params[:id])
  end

  def editLineup
    @team = Team.find(params[:id])
  end

  def minors
    @team = Team.find(params[:id])
    @pitchers = Player.where("team_id = ? AND level = ? AND position = ?", @team.id, "Minors", "P")
    @position_players = Player.where("team_id = ? AND level = ? AND position != ?", @team.id, "Minors", "P")
    # if @pitchers.length == 0
    #   @pitchers = []
    # end
    # if @position_players.length == 0
    #   @position_players = []
    # end
  end

  def transactions
    @transactions = Team.find(params[:id]).transactions
    @team = Team.find(params[:id])
  end

  def schedule
    @team = Team.find(params[:id])
  end

  def april
    @team = Team.find(params[:id])
    render :layout => false
  end

  def may
    @team = Team.find(params[:id])
    render :layout => false
  end

  def june
    @team = Team.find(params[:id])
    render :layout => false
  end

  def july
    @team = Team.find(params[:id])
    render :layout => false
  end

  def august
    @team = Team.find(params[:id])
    render :layout => false
  end

  def september
    @team = Team.find(params[:id])
    render :layout => false
  end

  def currentStandings
    @teams = Team.all
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
    puts "show method called in controller"
    if params[:id].to_i < 3
      puts "redirecting to free agent list..."
      redirect_to "/pages/freeAgents"
    end
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams
  # POST /teams.json
  def create
    @team = Team.new(team_params)

    respond_to do |format|
      if @team.save
        flash[:success] = "Team was successfully created."
        format.html { redirect_to @team }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        flash[:success] = "Team was successfully updated."
        format.html { redirect_to @team }
        format.json { render :show, status: :ok, location: @team }
      else
        if /\/teams\/[0-9]+$/.match(request.referrer) # Editing the lineup
          format.html { render :_position_form }
        else
          format.html { render :edit } # Editing the team info
        end
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @team.destroy
    respond_to do |format|
      flash[:success] = "Team was successfully destroyed."
      format.html { redirect_to teams_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_params
      params.require(:team).permit(:city, :name, :league, :division, :stadium,
                                  :capacity, :catcher, :designated_hitter, :first_base,
                                  :second_base, :third_base, :shortstop, :left_field,
                                  :right_field, :center_field, :bench1, :bench2, :bench3,
                                  :bench4, :lineup1, :lineup2, :lineup3, :lineup4, :lineup5,
                                  :lineup6, :lineup7, :lineup8, :lineup9, :sp1, :sp2, :sp3,
                                  :sp4, :sp5, :lr, :mr1, :mr2, :mr3, :su1, :su2, :cl, :user_id)
    end
end
