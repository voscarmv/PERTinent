require 'test_helper'

class PomodorosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pomodoro = pomodoros(:one)
  end

  test "should get index" do
    get pomodoros_url
    assert_response :success
  end

  test "should get new" do
    get new_pomodoro_url
    assert_response :success
  end

  test "should create pomodoro" do
    assert_difference('Pomodoro.count') do
      post pomodoros_url, params: { pomodoro: { content: @pomodoro.content, node_id: @pomodoro.node_id, user_id: @pomodoro.user_id } }
    end

    assert_redirected_to pomodoro_url(Pomodoro.last)
  end

  test "should show pomodoro" do
    get pomodoro_url(@pomodoro)
    assert_response :success
  end

  test "should get edit" do
    get edit_pomodoro_url(@pomodoro)
    assert_response :success
  end

  test "should update pomodoro" do
    patch pomodoro_url(@pomodoro), params: { pomodoro: { content: @pomodoro.content, node_id: @pomodoro.node_id, user_id: @pomodoro.user_id } }
    assert_redirected_to pomodoro_url(@pomodoro)
  end

  test "should destroy pomodoro" do
    assert_difference('Pomodoro.count', -1) do
      delete pomodoro_url(@pomodoro)
    end

    assert_redirected_to pomodoros_url
  end
end
