module AdminHelper

  def ban_button(user)
    unless user.nil?
      user.banned? ? (link_to 'unban', unban_admin_path(user)) : (link_to 'ban', ban_admin_path(user))
    end
  end

end
