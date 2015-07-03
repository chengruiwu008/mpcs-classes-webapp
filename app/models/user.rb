class User < ActiveRecord::Base

  MAX_COURSES = 4

  default_scope { order('users.created_at DESC') }

  validates :email, uniqueness: { case_sensitive: false }

  devise :trackable, :validatable, :ldap_authenticatable,
         authentication_keys: [:cnet]

  before_create :get_ldap_info
  after_update :send_roles_changed

  # Current user, passed in from ApplicationController.
  attr_accessor :this_user

  def full_name
    first_name + " " + last_name
  end

  def email_required?
    false
  end

  def password_required?
    false
  end

  def User.faculty_to_students(id_list)
    # Takes a hash where keys are user IDs and values are booleans determining
    # whether each user's type should be changed to "Student".

    id_list.each do |user_id, remove|
      User.find(user_id).update_attributes(type: "Student") if remove == "1"
    end
  end

  def update_bids(pref_params, quarter)
    pref_params.each do |course_id, pref|
      bid = Bid.find_by(course_id: course_id, student_id: self.id)
      if bid

        if pref == "No preference"
          bid.destroy
        else
          bid.update_attributes(preference: pref)
        end

      elsif pref != "No preference"
        self.bids.create(course_id: course_id,
                         preference: pref,
                         quarter_id: quarter.id)
      end
    end
  end

  def visible_quarters
    # All published quarters in the current academic year.
    Quarter.where(published: true).
     where(year: AcademicYear.current_year.year).to_a
  end

  def relevant_quarters
    if admin?
      # See all active quarters.
      Quarter.active_quarters.to_a

    elsif faculty?
      # See 1. quarters for which the proposal period is open, and
      # 2. quarters with passed proposal periods but for which the advisor
      # has submitted a proposal and which are not yet over.
      qs = Quarter.can_add_courses.to_set

      # Loop through this user's projects. For each project, check if the
      # quarter is active. If so, add it to the set.
      courses.each { |c| qs.add(c.quarter) if c.quarter.active? }

      qs.to_a

    elsif student?
      # Same rule as for advisors, except that it applies to submissions.
      qs = Quarter.open_for_bids.to_set
      bids.each { |b| qs.add(b.quarter) if b.quarter.try(:active?) }

      qs.to_a
    else # The user is not logged in.
      Quarter.active_quarters.to_a
    end
  end

  def admin?
    type == "Admin"
  end

  def faculty?
    type == "Faculty"
  end

  def student?
    type == "Student"
  end

  def send_roles_changed
    if this_user != self and type_changed?
      Notifier.roles_changed(self).deliver
    end
  end

  def get_ldap_info
    if Devise::LDAP::Adapter.get_ldap_param(self.cnet, 'uid')
      self.email = Devise::LDAP::Adapter.get_ldap_param(self.cnet, "mail").first

      # Set the student's first and last name to their cnet if their
      # LDAP directory is FERPA-protected
      firstname = (Devise::LDAP::Adapter.
                   get_ldap_param(self.cnet, "givenName") rescue nil)
      firstname = firstname ? firstname.first : self.cnet

      lastname = (Devise::LDAP::Adapter.
                  get_ldap_param(self.cnet, "sn") rescue nil)
      lastname = lastname ? lastname.first : self.cnet

      self.first_name = firstname
      self.last_name = lastname

      self.type = "Student" if self.type.blank?
    end
  end

  def missing_proposal_info?
    self.affiliation.blank? or self.department.blank?
  end

end
