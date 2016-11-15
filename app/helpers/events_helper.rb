module EventsHelper
  
  def agemax_check
    if @event.agemax >= 150
      false
    else
      true
    end
  end

  def agemin_check
    if @event.agemin < 0
      false
    else
      true
    end
  end

  def number_check
    if @event.number >= 194673
      false
    else
      true
    end
  end

end