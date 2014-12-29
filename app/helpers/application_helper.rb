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

end
