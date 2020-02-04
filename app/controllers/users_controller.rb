class UsersController < ApplicationController

  def new
    @user ||= User.new
  end

  def create
    @user = User.new(params.require(:user).permit(:username, :password, :password_confirmation))
    if @user.save
      login_as @user
      redirect_to root_url
    else
      flash[:notice] = @user.errors.to_a
      redirect_to signup_path
    end
  end
end
