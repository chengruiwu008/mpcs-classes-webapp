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

  def formatted_info(user)
    info = display_name(user)
    info << ", #{user.department}"  if user.department.present?
    info << ", #{user.affiliation}" if user.affiliation.present?
    info
  end

  def formatted_email(user)
    user.email
  end

  def formatted_status(course)
    course.draft ? "Draft" : "Published"
  end

  def preference(bid)
    bid.try(:preference) || "No preference"
  end

end
