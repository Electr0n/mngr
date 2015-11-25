class UsersController < ApplicationController

	before_action :authenticate_user!
	before_action :find_user, only: [:show, :edit, :update]

	def index
		@users = User.all 
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new
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
		@user.update_attributes()
	    if @user.errors.empty?
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
	end

	protected

	def find_user
		@user = User.find(params[:id])
	end

end
