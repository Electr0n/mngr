class TagsController < ApplicationController
  
  before_action :find_tag, only: [:show, :edit, :update, :destroy]

  def index
    @tags = Tag.all
  end

  def show
    # find_tag action
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      redirect_to tags_path
    else
      render 'new'
    end
  end

  def update
    @tag.update_attributes(tag_params)
    if @tag.errors.empty?
      redirect_to tag_path(@tag)
    else
      render 'edit'
    end
    # find_tag action
  end

  def edit
    # find_tag action
  end

  def destroy
    @tag.destroy
    redirect_to tags_path
    # find_tag action
  end

  def find_tag
    begin
      @tag = Tag.find(params[:id])
    rescue
      render file: "#{Rails.root}/public/404.html", layout: false, status: 404
    end
  end

  def tag_params
    params.require(:tag).permit(:name)
  end

end
