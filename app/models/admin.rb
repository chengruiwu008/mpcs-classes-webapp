class Admin < User
  devise :trackable, :validatable, :ldap_authenticatable,
  authentication_keys: [:cnet]

  before_validation :get_ldap_info

  # Fix routes for STI subclass of User so that we can call
  # current_user and generate a path in the view, rather than calling
  # user_path(current_user).
  def self.model_name
    User.model_name
  end
end
