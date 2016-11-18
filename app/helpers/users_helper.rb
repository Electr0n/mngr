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

  def users_age
    age = Time.now.year - @user.bday.year
    if (@user.bday + age.year) > Date.today
      age = age - 1
    end
  end
end
