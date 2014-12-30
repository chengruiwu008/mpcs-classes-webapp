class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # If not signed in
    can :read, Quarter

    unless user.new_record? # new_record => not signed in

      can :read, User, id: user.id
      can :read, Course

      if user.admin?
        can :manage, :all
      end

      if user.faculty?
      end

      if user.student?
      end

    end
  end

end
