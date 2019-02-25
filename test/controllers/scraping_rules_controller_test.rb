require 'test_helper'

class ScrapingRulesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @scraping_rule = scraping_rules(:one)
  end

  test "should get index" do
    get scraping_rules_url
    assert_response :success
  end

  test "should get new" do
    get new_scraping_rule_url
    assert_response :success
  end

  test "should create scraping_rule" do
    assert_difference('ScrapingRule.count') do
      post scraping_rules_url, params: { scraping_rule: {  } }
    end

    assert_redirected_to scraping_rule_url(ScrapingRule.last)
  end

  test "should show scraping_rule" do
    get scraping_rule_url(@scraping_rule)
    assert_response :success
  end

  test "should get edit" do
    get edit_scraping_rule_url(@scraping_rule)
    assert_response :success
  end

  test "should update scraping_rule" do
    patch scraping_rule_url(@scraping_rule), params: { scraping_rule: {  } }
    assert_redirected_to scraping_rule_url(@scraping_rule)
  end

  test "should destroy scraping_rule" do
    assert_difference('ScrapingRule.count', -1) do
      delete scraping_rule_url(@scraping_rule)
    end

    assert_redirected_to scraping_rules_url
  end
end
