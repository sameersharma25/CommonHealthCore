require 'test_helper'

class NotificationRulesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @notification_rule = notification_rules(:one)
  end

  test "should get index" do
    get notification_rules_url
    assert_response :success
  end

  test "should get new" do
    get new_notification_rule_url
    assert_response :success
  end

  test "should create notification_rule" do
    assert_difference('NotificationRule.count') do
      post notification_rules_url, params: { notification_rule: {  } }
    end

    assert_redirected_to notification_rule_url(NotificationRule.last)
  end

  test "should show notification_rule" do
    get notification_rule_url(@notification_rule)
    assert_response :success
  end

  test "should get edit" do
    get edit_notification_rule_url(@notification_rule)
    assert_response :success
  end

  test "should update notification_rule" do
    patch notification_rule_url(@notification_rule), params: { notification_rule: {  } }
    assert_redirected_to notification_rule_url(@notification_rule)
  end

  test "should destroy notification_rule" do
    assert_difference('NotificationRule.count', -1) do
      delete notification_rule_url(@notification_rule)
    end

    assert_redirected_to notification_rules_url
  end
end
