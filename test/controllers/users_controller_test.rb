require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get name:string" do
    get :name:string
    assert_response :success
  end

  test "should get role:string" do
    get :role:string
    assert_response :success
  end

  test "should get email:string" do
    get :email:string
    assert_response :success
  end

  test "should get password_digest:string" do
    get :password_digest:string
    assert_response :success
  end

end
