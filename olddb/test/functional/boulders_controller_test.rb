require 'test_helper'

class BouldersControllerTest < ActionController::TestCase
  setup do
    @boulder = boulders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:boulders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create boulder" do
    assert_difference('Boulder.count') do
      post :create, boulder: { climbers: @boulder.climbers, color_id: @boulder.color_id, description: @boulder.description, disable_date: @boulder.disable_date, level_intern: @boulder.level_intern, level_public: @boulder.level_public, manual_modified: @boulder.manual_modified, name: @boulder.name, points: @boulder.points, rating: @boulder.rating, remove_date: @boulder.remove_date, status: @boulder.status, votes: @boulder.votes, wall_from: @boulder.wall_from, wall_to: @boulder.wall_to }
    end

    assert_redirected_to boulder_path(assigns(:boulder))
  end

  test "should show boulder" do
    get :show, id: @boulder
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @boulder
    assert_response :success
  end

  test "should update boulder" do
    put :update, id: @boulder, boulder: { climbers: @boulder.climbers, color_id: @boulder.color_id, description: @boulder.description, disable_date: @boulder.disable_date, level_intern: @boulder.level_intern, level_public: @boulder.level_public, manual_modified: @boulder.manual_modified, name: @boulder.name, points: @boulder.points, rating: @boulder.rating, remove_date: @boulder.remove_date, status: @boulder.status, votes: @boulder.votes, wall_from: @boulder.wall_from, wall_to: @boulder.wall_to }
    assert_redirected_to boulder_path(assigns(:boulder))
  end

  test "should destroy boulder" do
    assert_difference('Boulder.count', -1) do
      delete :destroy, id: @boulder
    end

    assert_redirected_to boulders_path
  end
end
