require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest

  # login/create
  def test_login_success
    user = User.create!(username: 'test21', password: 'Test7pwd')

    post '/login', params: { user: { username: 'test21', password: 'Test7pwd' } }

    assert_response 302
    assert_equal session[:user_id], user.id
    assert_equal cookies[:remember_token], user.remember_token
  end

  def test_login_with_incorrect_pwd
    user = User.create!(username: 'test21', password: 'Test7pwd')

    post '/login', params: { user: { username: 'test21', password: 'Test1pwd' } }

    assert_response 200
    assert_template 'sessions/new'
    assert_nil session[:user_id]
    assert_nil cookies[:remember_token]
    assert_equal 'incorrect password', flash['warning']
  end

  def test_login_with_incorrect_username
    username = 'test31'
    User.find_by(username: username)&.destroy!

    post '/login', params: { user: { username: username, password: 'Test7pwd' } }

    assert_response 200
    assert_template 'sessions/new'
    assert_nil session[:user_id]
    assert_nil cookies[:remember_token]
    assert_equal "cannot find the user: #{ username }", flash['warning']
  end

  # logout/destroy
  def test_logout_success
    delete '/logout'

    assert_response 302
  end
end
