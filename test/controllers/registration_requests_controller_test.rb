require 'test_helper'

class RegistrationRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @registration_request = registration_requests(:one)
  end

  test "should get index" do
    get registration_requests_url
    assert_response :success
  end

  test "should get new" do
    get new_registration_request_url
    assert_response :success
  end

  test "should create registration_request" do
    assert_difference('RegistrationRequest.count') do
      post registration_requests_url, params: { registration_request: {  } }
    end

    assert_redirected_to registration_request_url(RegistrationRequest.last)
  end

  test "should show registration_request" do
    get registration_request_url(@registration_request)
    assert_response :success
  end

  test "should get edit" do
    get edit_registration_request_url(@registration_request)
    assert_response :success
  end

  test "should update registration_request" do
    patch registration_request_url(@registration_request), params: { registration_request: {  } }
    assert_redirected_to registration_request_url(@registration_request)
  end

  test "should destroy registration_request" do
    assert_difference('RegistrationRequest.count', -1) do
      delete registration_request_url(@registration_request)
    end

    assert_redirected_to registration_requests_url
  end
end
