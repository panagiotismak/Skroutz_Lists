class UsersController < ApplicationController

  before_action :set_user, only: [:edit, :update, :show]
  before_action :require_same_user, only: [:edit, :update, :show, :destroy]
  before_action :require_admin, only: [:destroy]

  def new
    if logged_in?
      redirect_to user_path(current_user)
    else
      @user = User.new
    end
  end

  def create
    binding.pry
    @user = User.new(user_params)
    if @user.save
      session[:user_id] =@user.id
      flash[:success] = "Welcome to Skroutz Lists #{@user.username}"
      redirect_to lists_path
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
      redirect_to lists_path
    else
      render 'edit'
    end
  end

  def show
    @user_lists = @user.lists.paginate(page: params[:page], per_page: 11)
  end

  private
  def user_params  
  	params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_same_user
    if current_user != @user && !current_user.admin?
      flash[:danger] = "You don't have permissions to view this page"
      redirect_to lists_path
    end
  end
  
  def require_admin
    if logged_in? && !current_user.admin?
      flash[:danger] = "Only admin users can perfom that action"
      redirect_to user_path(current_user)
    end
  end
end