require 'test_helper'

class ShowTemplatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @show_template = show_templates(:one)
  end

  test "should get index" do
    get show_templates_url
    assert_response :success
  end

  test "should get new" do
    get new_show_template_url
    assert_response :success
  end

  test "should create show_template" do
    assert_difference('ShowTemplate.count') do
      post show_templates_url, params: { show_template: {  } }
    end

    assert_redirected_to show_template_url(ShowTemplate.last)
  end

  test "should show show_template" do
    get show_template_url(@show_template)
    assert_response :success
  end

  test "should get edit" do
    get edit_show_template_url(@show_template)
    assert_response :success
  end

  test "should update show_template" do
    patch show_template_url(@show_template), params: { show_template: {  } }
    assert_redirected_to show_template_url(@show_template)
  end

  test "should destroy show_template" do
    assert_difference('ShowTemplate.count', -1) do
      delete show_template_url(@show_template)
    end

    assert_redirected_to show_templates_url
  end
end
