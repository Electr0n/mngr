module UsersHelper
  def resource_name
    :user
  end
 
  def resource
    @resource ||= User.new
  end
 
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def age(bday)
    unless bday.nil?
      age = Time.now.year - bday.year
      (bday + age.year) > Date.today ? age = age - 1 : age
    else
      ' - '
    end
  end

  def tags_list(tags)
    tags.any? ? tags.collect{|t| t.name}.join(", ") : 'No tags'
  end

  def edit_button
    link_to "Edit profile", edit_user_path(current_user), class: "btn btn-confirm user_edit" if can? :edit, @user
  end
  
end
