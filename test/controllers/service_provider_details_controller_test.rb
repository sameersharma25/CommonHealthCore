require 'test_helper'

class ServiceProviderDetailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @service_provider_detail = service_provider_details(:one)
  end

  test "should get index" do
    get service_provider_details_url
    assert_response :success
  end

  test "should get new" do
    get new_service_provider_detail_url
    assert_response :success
  end

  test "should create service_provider_detail" do
    assert_difference('ServiceProviderDetail.count') do
      post service_provider_details_url, params: { service_provider_detail: {  } }
    end

    assert_redirected_to service_provider_detail_url(ServiceProviderDetail.last)
  end

  test "should show service_provider_detail" do
    get service_provider_detail_url(@service_provider_detail)
    assert_response :success
  end

  test "should get edit" do
    get edit_service_provider_detail_url(@service_provider_detail)
    assert_response :success
  end

  test "should update service_provider_detail" do
    patch service_provider_detail_url(@service_provider_detail), params: { service_provider_detail: {  } }
    assert_redirected_to service_provider_detail_url(@service_provider_detail)
  end

  test "should destroy service_provider_detail" do
    assert_difference('ServiceProviderDetail.count', -1) do
      delete service_provider_detail_url(@service_provider_detail)
    end

    assert_redirected_to service_provider_details_url
  end
end
