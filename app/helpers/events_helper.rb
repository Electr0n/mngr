module EventsHelper
  
  def agemax_check
    if @event.agemax >= 150
      '- nvm'
    else
      @event.agemax
    end
  end

  def agemin_check
    if @event.agemin == 0
      'nvm'
    else
      @event.agemin
    end
  end

  def number_check
    if @event.number >= 194673
      'No matter'
    else
      @event.number
    end
  end

end