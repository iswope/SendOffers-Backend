require 'test_helper'

class ClientsControllerTest < ActionController::TestCase
  setup do
    @client = clients(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:clients)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create client" do
    assert_difference('Client.count') do
      post :create, client: { admin_notes: @client.admin_notes, company: @client.company, created_at: @client.created_at, email: @client.email, fax: @client.fax, firstname: @client.firstname, lastname: @client.lastname, mailing_address2: @client.mailing_address2, mailing_address: @client.mailing_address, mailing_city: @client.mailing_city, mailing_country: @client.mailing_country, mailing_state: @client.mailing_state, mailing_zip: @client.mailing_zip, phone: @client.phone, shipping_address2: @client.shipping_address2, shipping_address: @client.shipping_address, shipping_city: @client.shipping_city, shipping_country: @client.shipping_country, shipping_state: @client.shipping_state, shipping_zip: @client.shipping_zip, status: @client.status, updated_at: @client.updated_at, web: @client.web }
    end

    assert_redirected_to client_path(assigns(:client))
  end

  test "should show client" do
    get :show, id: @client
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @client
    assert_response :success
  end

  test "should update client" do
    put :update, id: @client, client: { admin_notes: @client.admin_notes, company: @client.company, created_at: @client.created_at, email: @client.email, fax: @client.fax, firstname: @client.firstname, lastname: @client.lastname, mailing_address2: @client.mailing_address2, mailing_address: @client.mailing_address, mailing_city: @client.mailing_city, mailing_country: @client.mailing_country, mailing_state: @client.mailing_state, mailing_zip: @client.mailing_zip, phone: @client.phone, shipping_address2: @client.shipping_address2, shipping_address: @client.shipping_address, shipping_city: @client.shipping_city, shipping_country: @client.shipping_country, shipping_state: @client.shipping_state, shipping_zip: @client.shipping_zip, status: @client.status, updated_at: @client.updated_at, web: @client.web }
    assert_redirected_to client_path(assigns(:client))
  end

  test "should destroy client" do
    assert_difference('Client.count', -1) do
      delete :destroy, id: @client
    end

    assert_redirected_to clients_path
  end
end
