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

  def link_to_add_fields(name, f, association)
    # binding.pry
    new_object = Tag.new
    id = new_object.object_id
    # fields = f.fields_for(association, new_object, child_index: id) do |builder|
    #   render("tag_fields", f: builder)
    # end
    fields = Tag.all
    link_to(name, '#', class: 'add_fields', data: {fields: fields})
  end

  # def link_to_add_fields(name, f, type)
  #   new_obj = f.object.send "build_#{type}"
  #   id = "new_#{type}"
  #   fields = f.send("#{type}_fields", new_obj, child_index: id) do |builder|
  #     render("tag_field", f: builder)
  #   end
  #   link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  # end
end