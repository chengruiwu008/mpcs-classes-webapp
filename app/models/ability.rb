class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # If not signed in
    can :read, Quarter
    can :global_index, Course
    can :index, Course
    can :read, Course do |course|
      course.quarter.published? && course.published? && !course.draft?
    end

    alias_action :edit, :update, to: :change

    unless user.new_record? # new_record => not signed in

      can :read, User,   id: user.id
      can :read, Course, draft: false

      if user.admin?
        can    :manage,          :all
        cannot :create_bids,     User
        cannot :view_my_bids,    User
        cannot :view_my_courses, User
      end

      if user.faculty?
        # TODO: Add dashboard ability to all user types (later)
        can :dashboard,             User, id: user.id
        can :view_my_courses,       User, id: user.id
        can :my_courses,            User, id: user.id
        can :update_affiliation_of, User, id: user.id
        can :read,                  User, id: user.id
        can :update,                User, id: user.id

        can :read,   Course, instructor_id: user.id
        can :change, Course, instructor_id: user.id
      end

      if user.student?
        can :view_my_bids,             User, id: user.id
        can :create_bids,              User, id: user.id
        can :update,                   User, id: user.id
        can :update_number_of_courses, User, id: user.id
        can :my_requests,              User, id: user.id
        can :my_schedule,              User, id: user.id
        can :update_requests,          User, id: user.id

        can :save_bid, Course # TODO: add restrictions
      end

    end
  end

end
