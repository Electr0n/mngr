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

  def full_name(user)
    user.name.nil? ? name = 'EMPTY' : name = user.name
    user.surname.nil? ? surname = 'EMPTY' : surname = user.surname
    name + ' ' + surname
  end

  def tags_list(tags)
    tags.any? ? tags.collect{|t| t.name}.join(", ") : 'No tags'
  end

  def edit_user_button
    link_to "Edit profile", edit_user_path(current_user), class: "btn btn-confirm user_edit" if can? :edit, @user
  end

  def country_name(user)
    Carmen::Country.coded(user.country).name unless user.country.blank?
  end
  
  def city_name(user)
    Carmen::Country.coded(user.country).subregions.coded(user.city).name unless user.city.blank?
  end

  def info(user)
    'ID: ' + user.id.to_s + '. ' + full_name(user)
  end

  def phones_info(p)
    unless p.nil?
      '+' + p.code.to_s + ' ' + p.number.to_s + ' (' + p.description + ')'
    else
      ''
    end
  end

end
