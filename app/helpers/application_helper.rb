module ApplicationHelper

  def full_site_title
    "Course Enrollment | Masters Program in Computer Science " +
    "| The University of Chicago"
  end

  def support_address
    "practicum-support@mailman.cs.uchicago.edu"
  end

  def github_page
    "https://github.com/uchicago-cs/mpcs-classes-webapp"
  end

  def flash_class(flash_type)
    case flash_type
    when "notice"  then "info"
    when "success" then "success"
    when "error"   then "danger"
    when "alert"   then "warning"
    else                flash_type
    end
  end

  def course_submission_navbar_link(quarter)
    if before_deadline?("course_submission") or current_user.admin?
      content_tag(:li, link_to("Submit a course",
                               new_course_path(year: quarter.year,
                                               season: quarter.season)))
    else
      content_tag(:li, link_to("Submit a course", '#'), class: "disabled")
    end
  end

  def before_deadline?(deadline)
    DateTime.now <= Quarter.active_quarter.deadline(deadline)
  end

end
