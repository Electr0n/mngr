class PhonesController < ApplicationController
  # before_action :find_phone, only: [:show, :edit, :update, :destroy]

  # def index
  #   @phones = Phone.all
  # end

  # def show
  #   # find_tag action
  # end

  # def new
  #   @phone = Phone.new
  # end

  # def create
  #   @phone = Phone.new(phone_params)
  #   if @phone.save
  #     redirect_to :back
  #   else
  #     render 'new'
  #   end
  # end

  # def update
  #   @phone.update_attributes(phone_params)
  #   if @phone.errors.empty?
  #     redirect_to phone_path(@phone)
  #   else
  #     render 'edit'
  #   end
  #   # find_tag action
  # end

  # def edit
  #   # find_tag action
  # end

  # def destroy
  #   @phone.destroy
  #   redirect_to :back
  #   # find_tag action
  # end

  # def find_phone
  #   begin
  #     @phone = Phone.find(params[:id])
  #   rescue
  #     render file: "#{Rails.root}/public/404.html", layout: false, status: 404
  #   end
  # end

end
