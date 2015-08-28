module UsersHelper

  def cnet_display_name(user)
    user.cnet
  end

  # We have a special method for the dashboard view since `@user` is `nil` for
  # the dashboard path that does not specify an ID param (`/dashboard`).
  # We don't modify `display_name`, because there are cases in which we want
  # to view the display name of a user who is different from the current user.
  #
  def dashboard_display_name
    display_name(@user || current_user)
  end

  def display_name(user)
    if user and user.first_name and user.last_name
      user.first_name + " " + user.last_name
    elsif !user
      # An admin created a course but hasn't yet chosen its instructor.
      "TBD"
    else
      ""
    end
  end

  def user_role_warning
    "If you update this user's roles (and you are not this user), an e-mail " +
    "will be sent to them."
  end

  def formatted_info(user)
    info = display_name(user)
    info << ", #{user.department}"  if user.department.present?
    info << ", #{user.affiliation}" if user.affiliation.present?
    info
  end

  def formatted_email(user)
    user.email
  end

  def preference(bid)
    bid.try(:preference) || "No preference"
  end

end
