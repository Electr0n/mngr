class UsersController < ApplicationController

  before_action :authenticate_user!, only: [:index, :edit, :update, :destroy]
  before_action :find_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.search(params[:name], params[:surname], params[:gender], 
      params[:date].try(:[], :year), params[:date].try(:[], :month), 
      params[:country], params[:city]).page(params[:page]).per(5)
  end

  def new
    if current_user.nil?
      @user = User.new
    else
      redirect_to user_path(current_user)
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "URA URA I VSE TAKOE"
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end

  def update
    # find_user action
    if current_user == @user
      @user.update_attributes(user_params)
      @user.tags = Tag.where(name: tags_params[:tags].split(','))
      if @user.errors.empty?
        sign_in(@user, :bypass => true)
        redirect_to user_path(@user)
      else
        redirect_to edit_user_path(@user)
      end
    else
      render file: "#{Rails.root}/public/403.html", layout: false, status: 403
    end
  end

  def edit
    # find_user action
    if current_user == @user
      @tags = Tag.all
    else
      render file: "#{Rails.root}/public/403.html", layout: false, status: 403
    end
  end

  def show
    # find_user action
    @events = @user.events.all.page(params[:page]).per(10)
  end

  def destroy
    if current_user == @user
      @user.destroy
      render "index"
    else
      render file: "#{Rails.root}/public/403.html", layout: false, status: 403
    end
  end

  def subregion_options
    render partial: 'subregion_select'
  end

  protected

  def find_user
    begin
      @user = User.find(params[:id])
    rescue
      render file: "#{Rails.root}/public/404.html", layout: false, status: 404
    end
  end

  def user_params
    params.require(:user).permit(:name, :surname, :email, :bday, :gender, :age,:phone, :hobby, :about, :password, :password_confirmation, :avatar, :country, :city)
  end

  def tags_params
    params.require(:user).permit(:tags)
  end

end
