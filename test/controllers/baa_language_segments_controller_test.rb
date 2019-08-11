require 'test_helper'

class BaaLanguageSegmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @baa_language_segment = baa_language_segments(:one)
  end

  test "should get index" do
    get baa_language_segments_url
    assert_response :success
  end

  test "should get new" do
    get new_baa_language_segment_url
    assert_response :success
  end

  test "should create baa_language_segment" do
    assert_difference('BaaLanguageSegment.count') do
      post baa_language_segments_url, params: { baa_language_segment: {  } }
    end

    assert_redirected_to baa_language_segment_url(BaaLanguageSegment.last)
  end

  test "should show baa_language_segment" do
    get baa_language_segment_url(@baa_language_segment)
    assert_response :success
  end

  test "should get edit" do
    get edit_baa_language_segment_url(@baa_language_segment)
    assert_response :success
  end

  test "should update baa_language_segment" do
    patch baa_language_segment_url(@baa_language_segment), params: { baa_language_segment: {  } }
    assert_redirected_to baa_language_segment_url(@baa_language_segment)
  end

  test "should destroy baa_language_segment" do
    assert_difference('BaaLanguageSegment.count', -1) do
      delete baa_language_segment_url(@baa_language_segment)
    end

    assert_redirected_to baa_language_segments_url
  end
end
