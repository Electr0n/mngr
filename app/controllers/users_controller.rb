class UsersController < ApplicationController

	before_action :authenticate_user!
	before_action :find_user, only: [:show, :edit, :update, :destroy]

	def index
		@users = User.all 
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		if @user.save
	      sign_in @user
	      flash[:success] = "URA URA I VSE TAKOE"
	      redirect_to @user
	    else
	      render 'new'
	    end
	end

	def update
		# find_user action
		@user.update_attributes(user_params)
	    if @user.errors.empty?
	    	sign_in(@user, :bypass => true)
	    	redirect_to user_path(@user)
	    else
	    	render "edit"
	    end
	end

	def edit
		# find_user action
	end

	def show
		# find_user action
	end

	def destroy
		@user.destroy
		render "index"
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
    	params.require(:user).permit(:avatar, :name, :surname, :email, :password, :password_confirmation)
  	end

end
