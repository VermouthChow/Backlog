require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def test_create_user_success
    before_count = User.count
    post '/users', { params: { user: { username: 'test21', password: 'T1234est', password_confirmation: 'T1234est' } } }
    user = User.find_by(username: 'test21')

    assert_response :redirect
    assert_equal before_count + 1, User.count
    assert_equal assigns(:user), user
    assert_equal session[:user_id], user.id
  end

  def test_create_user_fails
    before_count = User.count
    post '/users', { params: { user: { username: 'tes---21', password: 'T1234est', password_confirmation: 'T1234est' } } }

    assert_response :success
    assert_equal before_count, User.count
    assert_template 'users/new'
  end
end
