class UsersController < ApplicationController

  before_action :authenticate_user!, only: [:index, :edit, :update, :destroy]
  before_action :find_user, only: [:show, :edit, :update, :destroy, :del_request]

  def index
    if params[:q]
      # change params with calculated birthday by min age
      params[:q]['bday_lteq'] = (Time.now - params[:q]['bday_lteq'].to_i.years).to_s unless params[:q]['bday_lteq'].blank?
      # change params with calculated birthday by max age
      params[:q]['bday_gteq'] = (Time.now - params[:q]['bday_gteq'].to_i.years).to_s unless params[:q]['bday_gteq'].blank?
    end
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true).page(params[:page]).per(10)
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
      @user.roles << Role.where(name: 'user').first
      sign_in @user
      flash[:success] = "URA URA I VSE TAKOE"
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end

  def update
    # find_user action
    if can? :update, @user
      # updating primary attributes
      @user.update_attributes(user_params)
      # updateing tags
      @user.tags = Tag.where(name: tags_params[:tags]).uniq
      # updating phones
      phones_params[:phones_attributes].each do |data|
        @i = data.first.to_i
        if @user.phones[@i].nil?
          @user.phones.new(
            code:         data.last[:code],
            number:       data.last[:number],
            description:  data.last[:description]
            )
          @user.phones.last.save
        elsif data.last[:_destroy] == 'false'
          @user.phones[@i].update_attributes(
            code:         data.last[:code],
            number:       data.last[:number],
            description:  data.last[:description]
            )
        else
          @user.phones[@i].delete
        end
      end
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
    if can? :edit, @user
      @tags = Tag.all
    else
      render file: "#{Rails.root}/public/403.html", layout: false, status: 403
    end
  end

  def show
    # find_user action
    @events_f = @user.events.where(['date >= ?', Date.today]).page(params[:events_f]).per(5)
    @events_p = @user.events.where(['date < ?', Date.today]).page(params[:events_p]).per(5)
  end

  def destroy
    if can? :destroy, @user
      @user.destroy
      render "/admin/index"
    else
      render file: "#{Rails.root}/public/403.html", layout: false, status: 403
    end
  end

  def del_request
    if can? :del_request, @user
      @user.del_flag = true
      render file: "#{Rails.root}/public/system/users/deleted.html" if @user.save
    else
      render file: "#{Rails.root}/public/403.html", layout: false, status: 403
    end
  end

  def subregion_options
    render partial: 'subregion_select'
  end

  def city_search
    render partial: 'q_subregion_select'
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
    params.require(:user).permit(:name, :surname, :email, :bday, :gender, :hobby, :about, :del_flag, :password, :password_confirmation, :avatar, :country, :city)
  end

  def tags_params
    params.require(:user).permit(tags: [])
  end

  def phones_params
    params.require(:user).permit(phones_attributes: [:id, :code, :number, :description, :_destroy])
  end

end
