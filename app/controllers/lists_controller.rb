class ListsController < ApplicationController

  before_action :set_list, only: [:show, :flop, :visibility_status]
  
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
  
  def show

  end

  def flop
    @list.private = !@list.private # flop the status
    @list.save
    render json:{}, status: :ok
  end

  private
  def list_params  
    params.require(:list).permit(:name, :private)
  end

  def set_list
    @list = List.find(params[:id])
  end
end