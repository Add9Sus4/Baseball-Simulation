require 'test_helper'

class PlayersControllerTest < ActionController::TestCase
  setup do
    @player = players(:one)
  end

  # test "should get index" do
  #   get :index
  #   assert_response :success
  #   assert_not_nil assigns(:players)
  # end
  #
  # test "should get new" do
  #   get :new
  #   assert_response :success
  # end
  #
  # test "should create player" do
  #   assert_difference('Player.count') do
  #     post :create, player: { age: @player.age, agility: @player.agility, armStrength: @player.armStrength, batting_average: @player.batting_average, contact: @player.contact, control: @player.control, endurance: @player.endurance, fieldFlyball: @player.fieldFlyball, fieldGrounder: @player.fieldGrounder, fieldLiner: @player.fieldLiner, fieldPopup: @player.fieldPopup, first_name: @player.first_name, height: @player.height, intelligence: @player.intelligence, last_name: @player.last_name, location: @player.location, movement: @player.movement, patience: @player.patience, plate_vision: @player.plate_vision, position: @player.position, power: @player.power, pull_amount: @player.pull_amount, reactionTime: @player.reactionTime, salary: @player.salary, speed: @player.speed, team_id: @player.team_id, throwLong: @player.throwLong, throwMedium: @player.throwMedium, throwShort: @player.throwShort, uppercut_amount: @player.uppercut_amount, weight: @player.weight }
  #   end
  #
  #   assert_redirected_to player_path(assigns(:player))
  # end
  #
  # test "should show player" do
  #   get :show, id: @player
  #   assert_response :success
  # end
  #
  # test "should get edit" do
  #   get :edit, id: @player
  #   assert_response :success
  # end
  #
  # test "should update player" do
  #   patch :update, id: @player, player: { age: @player.age, agility: @player.agility, armStrength: @player.armStrength, batting_average: @player.batting_average, contact: @player.contact, control: @player.control, endurance: @player.endurance, fieldFlyball: @player.fieldFlyball, fieldGrounder: @player.fieldGrounder, fieldLiner: @player.fieldLiner, fieldPopup: @player.fieldPopup, first_name: @player.first_name, height: @player.height, intelligence: @player.intelligence, last_name: @player.last_name, location: @player.location, movement: @player.movement, patience: @player.patience, plate_vision: @player.plate_vision, position: @player.position, power: @player.power, pull_amount: @player.pull_amount, reactionTime: @player.reactionTime, salary: @player.salary, speed: @player.speed, team_id: @player.team_id, throwLong: @player.throwLong, throwMedium: @player.throwMedium, throwShort: @player.throwShort, uppercut_amount: @player.uppercut_amount, weight: @player.weight }
  #   assert_redirected_to player_path(assigns(:player))
  # end
  #
  # test "should destroy player" do
  #   assert_difference('Player.count', -1) do
  #     delete :destroy, id: @player
  #   end
  #
  #   assert_redirected_to players_path
  # end
end
