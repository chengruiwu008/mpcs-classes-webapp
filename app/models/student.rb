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

  def self.to_csv(year, season)
    csv = ""

    # Set up headers.
    col_headers = ['firstname', 'lastname', 'cnetid', 'numcourses']
    active_courses = Quarter.active_quarter.courses
    active_courses.each { |ac| col_headers << ac.number.to_s }

    csv << col_headers.join(',')
    csv << "\n"

    quarter = nil
    quarter = Quarter.find_by(year: year, season: season) if year && season

    # Grab data for each student.
    all.each do |s|
      include = false

      if quarter
        # Include this student in this .csv if they bid for a course in this
        # quarter.
        s.bids.each { |b| include = true and break if b.quarter == quarter }
      else
        include = true
      end

      next unless include

      student_data = [s.first_name, s.last_name, s.cnet, s.csv_num_courses]
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

  def csv_num_courses
    # Ensures that the numcourses column contains 0 for users who have logged
    # in but have not ranked any courses
    (bids.count > 0) ? number_of_courses : 0
  end

end
