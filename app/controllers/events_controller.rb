class EventsController < ApplicationController

  before_action :find_event, only: [:edit, :show, :update, :destroy, :join, :unfollow]

  def index
    @events = Event.all
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      current_user.events << @event
      redirect_to @event
    else
      render 'new'
    end
  end

  def show
    #action find_event
  end

  def edit
    #action find_event    
  end

  def update
    #action find_event  
    @event.update_attributes(event_params)
    if @event.errors.empty?
      redirect_to event_path(@event)
    else
      render "edit"
    end
  end
  
  def destroy
    #action find_event  
    @event.destroy
    redirect_to user_path(current_user)
  end

  def event_params
    params.require(:event).permit(:name, :date, :time, :description, :gender, :number,
      :agemin, :agemax, :location, :photo, :latitude, :longitude)
  end

  def find_event
    @event = Event.find(params[:id])
  end

  def join
    #action find_event
    if current_user.events.include?(@event)
      redirect_to current_user
    else
      current_user.events << @event
      redirect_to(:back)
    end 
    
  end

  def unfollow
    #action find_event
    if current_user.events.include?(@event)
      current_user.events.delete(@event)
      redirect_to(:back)
    else
      redirect_to (current_user)
    end
  end

end