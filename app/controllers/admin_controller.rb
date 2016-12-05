class AdminController < ApplicationController

  before_action :authenticate_user!
  before_action :find_user, only: [:ban, :unban]

  def index
    render file: "#{Rails.root}/public/403.html", layout: false, status: 403 unless can? :index, Admin
  end

  def users
    if can? :users, Admin
      @superadmins = User.joins(:roles).where(roles: {name: 'superadmin'}).page(params[:superadmins]).per(20)
      @admins = User.joins(:roles).where(roles: {name: 'admin'}).page(params[:admins]).per(20)
      @moderators = User.joins(:roles).where(roles: {name: 'moderator'}).page(params[:moderators]).per(20)
      @users = User.joins(:roles).where(roles: {name: 'user'}).page(params[:users]).per(20)
      @users_d = User.where(del_flag: true).page(params[:users_d]).per(20)
      @banned = User.joins(:roles).where(roles: {name: 'banned'}).page(params[:banned]).per(20)
      render 'users'
    else
      render file: "#{Rails.root}/public/403.html", layout: false, status: 403
    end
  end

  def events
    if can? :events, Admin
      @e_future = Event.where(['date > ?', Date.today]).page(params[:e_future]).per(20)
      @e_today = Event.where(date: Date.today).page(params[:e_today]).per(20)
      @e_past = Event.where(['date < ?', Date.today]).page(params[:e_past]).per(20)
      @e_del = Event.where(del_flag: true).page(params[:e_del]).per(20)
    else
      render file: "#{Rails.root}/public/403.html", layout: false, status: 403
    end
  end

  def ban
    if can? :ban, Admin
      @user.roles << Role.find_by_name('banned') unless @user.nil? || @user.banned?
      redirect_to(:back)
    else
      render file: "#{Rails.root}/public/403.html", layout: false, status: 403
    end
  end

  def unban
    if can? :unban, Admin
      @user.roles.delete(Role.find_by_name('banned')) if @user.banned? && !@user.nil?
      redirect_to(:back)
    else
      render file: "#{Rails.root}/public/403.html", layout: false, status: 403
    end
  end

  protected

  def find_user
    begin
      @user = User.find(params[:id])
    rescue
      render file: "#{Rails.root}/public/404.html", layout: false, status: 404
    end
  end

end
