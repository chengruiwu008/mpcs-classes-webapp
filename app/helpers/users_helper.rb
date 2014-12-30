module UsersHelper

  def cnet_display_name(user)
    user.cnet
  end

  def display_name(user)
    user.first_name + " " + user.last_name
  end

end
