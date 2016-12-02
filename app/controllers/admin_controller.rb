class AdminController < ApplicationController

  def index
    render file: "#{Rails.root}/public/403.html", layout: false, status: 403 unless can? :index, User
  end

  def users
    if can? :users, User
      @superadmins = User.joins(:roles).where(roles: {name: 'superadmin'}).page(params[:superadmins]).per(20)
      @admins = User.joins(:roles).where(roles: {name: 'admin'}).page(params[:admins]).per(20)
      @moderators = User.joins(:roles).where(roles: {name: 'moderator'}).page(params[:moderators]).per(20)
      @users = User.joins(:roles).where(roles: {name: 'user'}).page(params[:users]).per(20)
      @users_d = User.where(del_flag: true).page(params[:users_d]).per(20)
      render 'users'
    else
      render file: "#{Rails.root}/public/403.html", layout: false, status: 403
    end
  end

end
