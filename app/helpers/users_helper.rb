module UsersHelper

  def cnet_display_name(user)
    user.cnet
  end

  def display_name(user)
    user.first_name + " " + user.last_name
  end

  def user_role_warning
    "If you update this user's roles (and you are not this user), an e-mail " +
    "will be sent to them."
  end

end
