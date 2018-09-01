require 'test_helper'

class LineUsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @line_user = line_users(:one)
  end

  test "should get index" do
    get line_users_url
    assert_response :success
  end

  test "should get new" do
    get new_line_user_url
    assert_response :success
  end

  test "should create line_user" do
    assert_difference('LineUser.count') do
      post line_users_url, params: { line_user: { line_id: @line_user.line_id, line_username: @line_user.line_username, string: @line_user.string } }
    end

    assert_redirected_to line_user_url(LineUser.last)
  end

  test "should show line_user" do
    get line_user_url(@line_user)
    assert_response :success
  end

  test "should get edit" do
    get edit_line_user_url(@line_user)
    assert_response :success
  end

  test "should update line_user" do
    patch line_user_url(@line_user), params: { line_user: { line_id: @line_user.line_id, line_username: @line_user.line_username, string: @line_user.string } }
    assert_redirected_to line_user_url(@line_user)
  end

  test "should destroy line_user" do
    assert_difference('LineUser.count', -1) do
      delete line_user_url(@line_user)
    end

    assert_redirected_to line_users_url
  end
end
