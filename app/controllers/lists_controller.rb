class ListsController < ApplicationController

  def new

  end

  def create
    if @list.save
      flash[:success] = "List was successfully created"
      redirect_to user_path(current_user)
    else
      redirect_to root_path
    end
  end

  def edit

  end

  def update

  end

  def index
    @lists = List.all
  end
end