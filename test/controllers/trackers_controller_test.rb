require 'test_helper'

class TrackersControllerTest < ActionController::TestCase
  setup do
    @tracker = trackers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:trackers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tracker" do
    assert_difference('Tracker.count') do
      post :create, tracker: { comp: @tracker.comp, created: @tracker.created, disc: @tracker.disc, eta: @tracker.eta, finished: @tracker.finished, integer: @tracker.integer, noc: @tracker.noc, owner: @tracker.owner, staging: @tracker.staging, ticket_id: @tracker.ticket_id, tow: @tracker.tow }
    end

    assert_redirected_to tracker_path(assigns(:tracker))
  end

  test "should show tracker" do
    get :show, id: @tracker
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tracker
    assert_response :success
  end

  test "should update tracker" do
    patch :update, id: @tracker, tracker: { comp: @tracker.comp, created: @tracker.created, disc: @tracker.disc, eta: @tracker.eta, finished: @tracker.finished, integer: @tracker.integer, noc: @tracker.noc, owner: @tracker.owner, staging: @tracker.staging, ticket_id: @tracker.ticket_id, tow: @tracker.tow }
    assert_redirected_to tracker_path(assigns(:tracker))
  end

  test "should destroy tracker" do
    assert_difference('Tracker.count', -1) do
      delete :destroy, id: @tracker
    end

    assert_redirected_to trackers_path
  end
end
