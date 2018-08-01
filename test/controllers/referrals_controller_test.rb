require 'test_helper'

class ReferralsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @referral = referrals(:one)
  end

  test "should get index" do
    get referrals_url
    assert_response :success
  end

  test "should get new" do
    get new_referral_url
    assert_response :success
  end

  test "should create referral" do
    assert_difference('Referral.count') do
      post referrals_url, params: { referral: {  } }
    end

    assert_redirected_to referral_url(Referral.last)
  end

  test "should show referral" do
    get referral_url(@referral)
    assert_response :success
  end

  test "should get edit" do
    get edit_referral_url(@referral)
    assert_response :success
  end

  test "should update referral" do
    patch referral_url(@referral), params: { referral: {  } }
    assert_redirected_to referral_url(@referral)
  end

  test "should destroy referral" do
    assert_difference('Referral.count', -1) do
      delete referral_url(@referral)
    end

    assert_redirected_to referrals_url
  end
end
