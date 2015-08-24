require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get upload" do
    get :upload
    assert_response :success
  end

  test "should get download" do
    get :download
    assert_response :success
  end

  test "should get delete" do
    get :delete
    assert_response :success
  end

  test "should get preference" do
    get :preference
    assert_response :success
  end

end
