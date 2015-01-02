class User < ActiveRecord::Base

  default_scope { order('users.created_at DESC') }
  scope :admins, -> { where(type: "Admin") }

  validates :email, uniqueness: { case_sensitive: false }

  devise :trackable, :validatable, :ldap_authenticatable,
         authentication_keys: [:cnet]

  before_validation :get_ldap_info
  after_update :send_roles_changed

  # Current user, passed in from ApplicationController.
  attr_accessor :this_user

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

      bids.each { |b| qs.add(b.quarter) if b.quarter.active? }

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
      self.email = Devise::LDAP::Adapter.
        get_ldap_param(self.cnet, "mail").first

      self.first_name = (Devise::LDAP::Adapter.
                         get_ldap_param(self.cnet,
                                        "givenName") rescue nil).first

      self.last_name = (Devise::LDAP::Adapter.
                        get_ldap_param(self.cnet, "sn") rescue nil).first

      self.type = "Student"
    end
  end

end
