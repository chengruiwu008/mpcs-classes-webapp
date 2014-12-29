class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # If not signed in
    can :read, Quarter


    if user.admin?
      can :manage, :all
    end

    if user.faculty?
      can :read, Course
    end

    if user.student?
      can :read, Course
    end
  end
end
