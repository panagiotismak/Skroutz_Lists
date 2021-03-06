class ListsController < ApplicationController

  before_action :set_list, except: [:new, :create, :index]
  before_action :require_same_user, only: [:edit, :update, :flop, :add_product, :remove_product]
  before_action :set_skroutz_connection, only: [:show, :add_product, :skus_associated_to_list, :search_product]
  before_action :skus_associated_to_list, only: [:show, :search_product, :products_for_pagination]
  before_action :products_for_pagination, only: [:show, :search_product]
  
  # Get /lists/new
  def new; end
  
  # Post /lists
  def create
    @list = List.new(list_params)
    @list.user = current_user
    if @list.save
      flash[:success] = "List was successfully created"
    else
      flash[:danger] = @list.errors.full_messages.first
    end
    redirect_to user_path(current_user)
  end
  
  # Get /lists/:id/edit
  def edit; end
  
  # Put /lists/:id
  def update
    if @list.update(list_params)
      flash[:success] = "List name was successfully updated"
    else
      flash[:danger] = @list.errors.full_messages.first
    end
    redirect_to user_path(current_user)
  end
  
  # Get /lists
  def index
    if params[:pagination_order].present? && params[:pagination_order]=="votes"
      @lists = List.visible.order("votes_count DESC").paginate(page: params[:page], per_page: 12)
    else
      params[:pagination_order]=""
      @lists = List.visible.order("created_at DESC").paginate(page: params[:page], per_page: 12)
    end
  end
  
  # Get /lists/:id
  def show; end
  
  # Delete /lists/:id
  def destroy
    @list.destroy
    flash[:danger] = "List was successfully deleted"
    redirect_to user_path(current_user)
  end
  
  # Get /lists/:id/flop
  def flop
    @list.private = !@list.private # flop the status
    if @list.save
      render json:{}, status: :ok
    else
      render json:{}, status: :unprocessable_entity
    end
  end
  
  #  POST   /lists/:id/add_product
  def add_product
    @sku_list=SkuList.new(sku_id: params[:skuid], list_id: @list.id)
    if !@sku_list.save
      skus_associated_to_list
    end
    redirect_to list_path(@list) 
  end
  
  # Put /lists/:id/remove_product
  def remove_product
    @list.sku_lists.where(sku_id: params[:skuid].to_i).destroy_all
    flash[:success]="Product deleted"
    redirect_to list_path(@list)
  end
  
  # Get /lists/:id/search_product
  def search_product
    @product=@skroutz.search_sku_by_id(params[:skuid])
    if !@product.present?
      flash[:danger]="This sku doesn't exist"
      return redirect_to list_path(@list)
    end
    @modal=true
    render 'show'
  end
  
  def vote
    list_vote=ListVote.new(list_id: @list.id, user_id: current_user.id)
    if list_vote.save
      flash[:success]="Thank you for voting"
    else
      flash[:danger]="Sorry your vote could not be saved"
    end
    redirect_to list_path(@list)
  end

  def unvote
    list_vote=ListVote.where(list_id: @list.id, user_id: current_user.id)
    list_vote.destroy_all
    redirect_to list_path(@list)
  end

  private
  def list_params  
    params.require(:list).permit(:name, :private)
  end

  def set_list
    @list = List.find(params[:id])
  end

  def require_same_user
    if current_user != @list.user && !current_user.admin?
      flash[:danger] = "You don't have permissions to view this page"
      redirect_to lists_path
    end
  end

  def set_skroutz_connection
    @skroutz=Skroutzapi.new
  end
  
  def skus_associated_to_list
    @products=[]
    @list.sku_lists.pluck(:sku_id).each do |variable|
      @products << @skroutz.search_sku_by_id(variable)
    end
  end  

  def products_for_pagination
    @list_products = @products.paginate(page: params[:page], per_page: 11)
  end
end