require 'test_helper'

class CloudControllerTest < ActionController::TestCase
  test "should get dropauth" do
    get :dropauth
    assert_response :success
  end

  test "should get boxauth" do
    get :boxauth
    assert_response :success
  end

  test "should get dropup" do
    get :dropup
    assert_response :success
  end

  test "should get boxup" do
    get :boxup
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

end
