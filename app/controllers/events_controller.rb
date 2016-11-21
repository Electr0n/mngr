class EventsController < ApplicationController

  before_action :find_event, only: [:edit, :show, :update, :destroy, :join, 
    :unfollow, :del_request]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :join, :unfollow, :del_request]

  def index
    if params[:q]
      params[:q]['tags_name_in'].delete("") 
    end
    @q = Event.ransack(params[:q])
    @events = @q.result(distinct: true).page(params[:page]).per(10)
  end

  def new
    @event = Event.new
  end

  def create 
    params_init if event_params
    @event = Event.new(event_params)
    if (can? :create, @event) && @event.save
      current_user.products << @event
      redirect_to @event
    else
      render 'new'
    end
  end

  def show
    # action find_event
  end

  def edit
    # action find_event
    if can? :edit, @event
      @tags = Tag.all
    else
      render file: "#{Rails.root}/public/403.html", layout: false, status: 403
    end
  end

  def update
    # action find_event
    if can? :update, @event
      params_init
      @event.update_attributes(event_params)
      @event.tags = Tag.where(name: tags_params[:tags].split(','))
      if @event.errors.empty?
        redirect_to event_path(@event)
      else
        render "edit"
      end
    else
      render file: "#{Rails.root}/public/403.html", layout: false, status: 403
    end
  end

  def destroy
    # action find_event 
    if can? :destroy, @event 
      @event.destroy
      redirect_to user_path(current_user)
    else
      render file: "#{Rails.root}/public/403.html", layout: false, status: 403
    end
  end

  def event_params
    params.require(:event).permit(:name, :date, :time, :description, :gender, 
      :number, :agemin, :agemax, :location, :photo, :latitude, :longitude, :del_flag, tags_attributes: [:id, :name])
  end

  def tags_params
    params.require(:event).permit(:tags)
  end

  def find_event
    @event = Event.find(params[:id])
  end

  def del_request
    if can? :del_request, @event
      @event.del_flag = true
      render file: "#{Rails.root}/public/system/events/deleted.html" if @event.save
    else
      render file: "#{Rails.root}/public/403.html", layout: false, status: 403
    end
  end

  def params_init
    params[:event][:agemax] = 150 if params[:event][:agemax].blank?
    params[:event][:agemin] = 0 if params[:event][:agemin].blank?
    params[:event][:number] = 194673 if params[:event][:number].blank?
  end

  def join
    # action find_event
    if current_user.events.include?(@event)
      redirect_to current_user
    else
      current_user.events << @event
      redirect_to(:back)
    end 
  end

  def unfollow
    # action find_event
    if current_user.events.include?(@event)
      current_user.events.delete(@event)
      redirect_to(:back)
    else
      redirect_to (current_user)
    end
  end

end