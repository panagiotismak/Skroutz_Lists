class UsersController < ApplicationController

  before_action :set_user, only: [:edit, :update, :show]

  def new
   @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to Skroutz Lists #{@user.username}"
      redirect_to user_path(@user)
  	else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)
      flash[:success] = "User was successfully updated"
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  def show
    
  end

  private
  def user_params  
  	params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end
end