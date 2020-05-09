require "application_system_test_case"

class PomodorosTest < ApplicationSystemTestCase
  setup do
    @pomodoro = pomodoros(:one)
  end

  test "visiting the index" do
    visit pomodoros_url
    assert_selector "h1", text: "Pomodoros"
  end

  test "creating a Pomodoro" do
    visit pomodoros_url
    click_on "New Pomodoro"

    fill_in "Content", with: @pomodoro.content
    fill_in "Node", with: @pomodoro.node_id
    fill_in "User", with: @pomodoro.user_id
    click_on "Create Pomodoro"

    assert_text "Pomodoro was successfully created"
    click_on "Back"
  end

  test "updating a Pomodoro" do
    visit pomodoros_url
    click_on "Edit", match: :first

    fill_in "Content", with: @pomodoro.content
    fill_in "Node", with: @pomodoro.node_id
    fill_in "User", with: @pomodoro.user_id
    click_on "Update Pomodoro"

    assert_text "Pomodoro was successfully updated"
    click_on "Back"
  end

  test "destroying a Pomodoro" do
    visit pomodoros_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Pomodoro was successfully destroyed"
  end
end
