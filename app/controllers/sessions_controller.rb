class SessionsController < ApplicationController

  def new
    @user = User.new
  end

  def create
    login_params = params.require(:user).permit(:username, :password)
    @user = User.find_by('lower(username) = lower(?)', login_params[:username])

    if @user&.authenticate(login_params[:password])
      login_as @user
      remember_me
      redirect_to root_url 
    else
      flash[:notice]= @user ? ['incorrect password'] : ["the user: #{ login_params[:username] } does not exist"]
      @user = User.new
      render :new
    end
  end

  def destroy
    logout
    redirect_to login_path
  end
end
