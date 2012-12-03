require 'test_helper'

class ReachmailgroupsControllerTest < ActionController::TestCase
  setup do
    @reachmailgroup = reachmailgroups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:reachmailgroups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create reachmailgroup" do
    assert_difference('Reachmailgroup.count') do
      post :create, reachmailgroup: { client_id: @reachmailgroup.client_id, groupid: @reachmailgroup.groupid, isdeleted: @reachmailgroup.isdeleted, name: @reachmailgroup.name }
    end

    assert_redirected_to reachmailgroup_path(assigns(:reachmailgroup))
  end

  test "should show reachmailgroup" do
    get :show, id: @reachmailgroup
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @reachmailgroup
    assert_response :success
  end

  test "should update reachmailgroup" do
    put :update, id: @reachmailgroup, reachmailgroup: { client_id: @reachmailgroup.client_id, groupid: @reachmailgroup.groupid, isdeleted: @reachmailgroup.isdeleted, name: @reachmailgroup.name }
    assert_redirected_to reachmailgroup_path(assigns(:reachmailgroup))
  end

  test "should destroy reachmailgroup" do
    assert_difference('Reachmailgroup.count', -1) do
      delete :destroy, id: @reachmailgroup
    end

    assert_redirected_to reachmailgroups_path
  end
end
