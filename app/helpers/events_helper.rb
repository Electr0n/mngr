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

end