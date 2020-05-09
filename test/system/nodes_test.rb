require "application_system_test_case"

class NodesTest < ApplicationSystemTestCase
  setup do
    @node = nodes(:one)
  end

  test "visiting the index" do
    visit nodes_url
    assert_selector "h1", text: "Nodes"
  end

  test "creating a Node" do
    visit nodes_url
    click_on "New Node"

    fill_in "Description", with: @node.description
    fill_in "Name", with: @node.name
    fill_in "User", with: @node.user_id
    click_on "Create Node"

    assert_text "Node was successfully created"
    click_on "Back"
  end

  test "updating a Node" do
    visit nodes_url
    click_on "Edit", match: :first

    fill_in "Description", with: @node.description
    fill_in "Name", with: @node.name
    fill_in "User", with: @node.user_id
    click_on "Update Node"

    assert_text "Node was successfully updated"
    click_on "Back"
  end

  test "destroying a Node" do
    visit nodes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Node was successfully destroyed"
  end
end
