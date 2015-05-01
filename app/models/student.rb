class Student < User

  default_scope { order('users.created_at DESC') }

  devise :trackable, :validatable, :ldap_authenticatable,
         authentication_keys: [:cnet]

  #before_validation :get_ldap_info

  has_many :bids

  # Fix routes for STI subclass of User so that we can call
  # current_user and generate a path in the view, rather than calling
  # user_path(current_user).
  def self.model_name
    User.model_name
  end

  def self.to_csv
    csv = ""

    # set up headers
    col_headers = ['firstname', 'lastname', 'cnetid', 'numcourses']
    active_courses = Quarter.active_quarter.courses
    active_courses.each { |ac| col_headers << ac.number.to_s }

    csv << col_headers.join(',')
    csv << "\n"

    # grab data for each student
    all.each do |s|
      student_data = [s.first_name, s.last_name, s.cnet, s.number_of_courses]

      active_courses.each { |ac| student_data << s.course_rank(ac).to_s }

      csv << student_data.join(',')
      csv << "\n"
    end

    csv
  end

  def course_rank(course)
    bids.each { |b| return b.preference if b.course_id == course.id }
    nil
  end

end
