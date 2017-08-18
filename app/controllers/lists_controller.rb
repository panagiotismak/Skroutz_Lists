class ListsController < ApplicationController

  before_action :set_list, only: [:show, :flop, :visibility_status, :destroy, :add_product, :remove_product, :search_product]
  before_action :require_same_user, only: [:show]
  before_action :set_skroutz_connection, only: [:show, :add_product, :skus_associated_to_list, :search_product]
  before_action :skus_associated_to_list, only: [:show, :search_product]
  
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
    @users = User.all
    @lists = List.visible.paginate(page: params[:page], per_page: 12)
  end
  
  def show
    @list_products = @list.sku_lists.paginate(page: params[:page], per_page:5)
  end

  def destroy
    @list.destroy
    flash[:danger] = "List was successfully deleted"
    redirect_to user_path(current_user)
  end

  def flop
    @list.private = !@list.private # flop the status
    @list.save
    render json:{}, status: :ok
  end
  
  #  POST   /lists/:id/add_product
  def add_product
    product=@skroutz.search_sku_by_id(params[:skuid])
    if !product.present?
      flash[:danger]="This sku doesn't exist"
      return redirect_to list_path(@list)
    end
    @sku_list=SkuList.new(sku_id: params[:skuid], list_id: @list.id)
      if @sku_list.save
        redirect_to list_path(@list)
      else
        skus_associated_to_list
        render 'show'
      end 
  end
  
  def remove_product
    @list.sku_lists.where(sku_id: params[:skuid].to_i).destroy_all
    redirect_to list_path(@list)
  end
  
  def search_product
    product=@skroutz.search_sku_by_id(params[:skuid])
    if !product.present?
      flash[:danger]="This sku doesn't exist"
      return redirect_to list_path(@list)
    end
    @modal=true
    render 'show'
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
    @product=@skroutz.search_sku_by_id(params[:skuid])
    @products=[]
    @list.sku_lists.pluck(:sku_id).each do |variable|
      @products << @skroutz.search_sku_by_id(variable)
    end
  end  
end