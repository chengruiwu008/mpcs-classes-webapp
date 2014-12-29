class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # If not signed in
    can :read, Quarter
    can :read, Course
  end
end
