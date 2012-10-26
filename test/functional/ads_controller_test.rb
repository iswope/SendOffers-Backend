require 'test_helper'

class AdsControllerTest < ActionController::TestCase
  setup do
    @ad = ads(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ads)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ad" do
    assert_difference('Ad.count') do
      post :create, ad: { active: @ad.active, blast_id: @ad.blast_id, client_id: @ad.client_id, dist_art: @ad.dist_art, end: @ad.end, imagemap: @ad.imagemap, start: @ad.start, subject: @ad.subject, subject_line: @ad.subject_line, supp_art: @ad.supp_art }
    end

    assert_redirected_to ad_path(assigns(:ad))
  end

  test "should show ad" do
    get :show, id: @ad
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ad
    assert_response :success
  end

  test "should update ad" do
    put :update, id: @ad, ad: { active: @ad.active, blast_id: @ad.blast_id, client_id: @ad.client_id, dist_art: @ad.dist_art, end: @ad.end, imagemap: @ad.imagemap, start: @ad.start, subject: @ad.subject, subject_line: @ad.subject_line, supp_art: @ad.supp_art }
    assert_redirected_to ad_path(assigns(:ad))
  end

  test "should destroy ad" do
    assert_difference('Ad.count', -1) do
      delete :destroy, id: @ad
    end

    assert_redirected_to ads_path
  end
end
