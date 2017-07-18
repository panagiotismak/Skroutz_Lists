class ListsController < ApplicationController

  before_action :current_user

  def new

  end

  def create

  end

  def edit

  end

  def update

  end

  def index
    @lists = List.all
  end
end