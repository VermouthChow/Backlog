class UsersController < ApplicationController

  def new
    User.new
  end

  def create
    @user = User.new(params.require(:user).permit(:username, :password, :password_confirmation))
    if @user.save
      login_as @user
      redirect_to root_url
    else
      render :new
    end
  end
end
