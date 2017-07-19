class ListsController < ApplicationController
  
  def new

  end

  def create
    @list = List.new(list_params)
    @list.user = current_user
    if @list.save
      flash[:success] = "List was successfully created"
      redirect_to user_path(current_user)
    else
      flash[:danger] = @list.errors.full_messages.first
      redirect_to user_path(current_user)
    end
  end

  def edit

  end

  def update

  end

  def index
    @lists = List.all
  end

  private
  def list_params  
    params.require(:list).permit(:name, :private)
  end
end