class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  class AccessDenied < Exception; end

  def login_required
    redirect_to login_path unless login?
  end

  def current_user
    @current_user ||= (login_from_session || login_from_cookies)
  end

  def login_as(user)
    session[:user_id] = user.id
    @current_user = user
  end

  def login?
    current_user.present?
  end

  def logout
    session.delete(:user_id)
    @current_user = nil
    forget_me
  end

  def login_from_session
    if session[:user_id].present?
      begin
        User.find session[:user_id]
      rescue
        session[:user_id] = nil
      end
    end
  end

  def login_from_cookies
    if cookies[:remember_token].present? && user = User.find_by_remember_token(cookies[:remember_token])
      session[:user_id] = user.id
      user
    else
      forget_me if cookies[:remember_token].present?
      nil
    end
  end

  def remember_me
    cookies[:remember_token] = {
      value: current_user.remember_token,
      expires: 1.weeks.from_now
    } 
  end

  def forget_me
    cookies.delete(:remember_token)
  end
end
