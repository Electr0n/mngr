module EventsHelper

  def number?(number)
    number < 194673 ? true : false
  end

  def age_min?(age)
    age > 0 ? true : false
  end

  def age_max?(age)
    age < 150 ? true : false
  end

  def number(number)
    number < 194673 ? number : ' > 100 000'
  end

  def age_range(min, max)
    min > 0   ? min : min = '0+'
    max < 149 ? max : max = '99+'
    range = min.to_s + ' - ' + max.to_s
  end

  def tags_list(tags)
    tags.any? ? tags.collect{|t| t.name}.join(", ") : 'No tags'
  end

  def position_init(event)
    event.latitude.nil?   ? event.latitude  = 53.7098 : event.latitude
    event.longitude.nil?  ? event.longitude = 27.9534 : event.longitude
  end

  def edit_event_button
    link_to "Edit", edit_event_path(@event), class: "btn btn-confirm" if can? :edit, @event
  end

  def delete_event_button
    link_to "Delete", @event, method: :delete, class: "btn btn-confirm" if can? :delete, @event
  end

  def follow_event_button
    if !current_user.nil? && current_user.events.include?(@event)
      link_to "unfollow", unfollow_event_path(@event), class: "btn btn-confirm"
    else
      link_to "join", join_event_path(@event), class: "btn btn-confirm"
    end
  end

end