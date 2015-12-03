class EventsController < ApplicationController

  before_action :find_event, only: [:edit, :show, :update, :destroy, :join, :unfollow]

  def join
    current_user.events << @event
    redirect_to(:back)
  end

  def unfollow
    current_user.events.delete(@event)
    redirect_to(:back)
  end

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
    
  end

  def edit
    
  end

  def update
    @event.update_attributes(event_params)
    if @event.errors.empty?
      redirect_to event_path(@event)
    else
      render "edit"
    end
  end
  
  def destroy
    @event.destroy
    redirect_to user_path(current_user)
  end

  def event_params
    params.require(:event).permit(:name, :date, :time, :etype, :description, :gender, :number,
      :agemin, :agemax, :location, :photo)
  end

  def find_event
    @event = Event.find(params[:id])
  end

end