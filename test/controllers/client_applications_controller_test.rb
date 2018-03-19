require 'test_helper'

class ClientApplicationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @client_application = client_applications(:one)
  end

  test "should get index" do
    get client_applications_url
    assert_response :success
  end

  test "should get new" do
    get new_client_application_url
    assert_response :success
  end

  test "should create client_application" do
    assert_difference('ClientApplication.count') do
      post client_applications_url, params: { client_application: {  } }
    end

    assert_redirected_to client_application_url(ClientApplication.last)
  end

  test "should show client_application" do
    get client_application_url(@client_application)
    assert_response :success
  end

  test "should get edit" do
    get edit_client_application_url(@client_application)
    assert_response :success
  end

  test "should update client_application" do
    patch client_application_url(@client_application), params: { client_application: {  } }
    assert_redirected_to client_application_url(@client_application)
  end

  test "should destroy client_application" do
    assert_difference('ClientApplication.count', -1) do
      delete client_application_url(@client_application)
    end

    assert_redirected_to client_applications_url
  end
end
