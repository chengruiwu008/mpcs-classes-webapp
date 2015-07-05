FactoryGirl.define do

  # has_many:   Use FactoryGirl's callbacks.
  # belongs_to: Write `thing_this_belong_to` in the belonging model.

  factory :academic_year, class: AcademicYear do
    year { Date.today.year }

    trait :current do
      year { current_academic_year }
    end

    trait :not_current do
      year { current_academic_year + 20 }
    end
  end

  factory :user, class: User do
    sequence(:email)      { |n| "user_#{n}@university.edu" }
    sequence(:first_name) { |n| "User" }
    sequence(:last_name)  { |n| "#{n}" }
    sequence(:cnet)       { |n| "user#{n}" }
    password              "foobarfoo"
    password_confirmation "foobarfoo"

    trait :student do
      sequence(:email) { |n| "student_#{n}@university.edu" }
      type "Student"
    end

    trait :faculty do
      sequence(:email) { |n| "instructor_#{n}@university.edu" }
      type "Faculty"
    end

    trait :admin do
      sequence(:email) { |n| "admin_#{n}@university.edu" }
      type "Admin"
    end

    trait :guest do
      # Nothing, since they're not logged in
    end

    factory :student, traits: [:student]
    factory :faculty, traits: [:faculty]
    factory :admin,   traits: [:admin]
    factory :guest,   traits: [:guest]
  end

  factory :quarter do
    # Not DRY
    season_dates = { "spring" => "4th Monday in March",
                     "summer" => "4th Monday in June",
                     "autumn" => "4th Monday in September",
                     "winter" => "1st Monday in January" }
    deadline_weeks = { "proposal" => 2, "submission" => 5, "decision" => 7,
                       "admin" => 8 }

    year { Date.today.year }
    season { %w(spring summer autumn winter)[((Time.now.month - 1) / 3)-1] }
    start_date { Chronic.parse(season_dates[season.downcase],
                 now: Time.local(year, 1, 1, 12, 0, 0)).to_datetime }
    course_submission_deadline { start_date +
      deadline_weeks["course"].weeks + 4.days + 5.hours }
    student_bidding_deadline { start_date +
      deadline_weeks["bid"].weeks + 4.days + 5.hours }

    trait :can_create_course do
      course_submission_deadline { DateTime.tomorrow }
    end

    trait :can_create_bid do
      student_bidding_deadline { DateTime.tomorrow }
    end

    trait :cannot_create_project do
      course_submission_deadline { DateTime.yesterday }
    end

    trait :cannot_create_bid do
      student_bidding_deadline { DateTime.yesterday }
    end

    trait :later_end_date do
      end_date { DateTime.now + 11.weeks }
    end

    trait :earlier_start_date do
      start_date { DateTime.now - 11.weeks }
    end

    trait :active do
      # Start date is before today and end date is after today
      earlier_start_date
      later_end_date
    end

    trait :inactive do
      start_date { DateTime.now + 11.weeks }
      end_date   { DateTime.now + 22.weeks }
    end

    trait :no_deadlines_passed do
      can_create_course
      later_end_date
    end

    trait :all_deadlines_passed do
      earlier_start_date
      cannot_create_submission
      cannot_create_project
      advisor_cannot_decide
      later_end_date
    end

    # FIXME: is this inactive?
    trait :inactive_and_deadlines_passed do
      earlier_start_date
      end_date { start_date + 9.weeks + 5.days }
      project_proposal_deadline { start_date + 1.day }
      student_submission_deadline { start_date + 2.days }
      advisor_decision_deadline { start_date + 3.days }
      admin_publish_deadline { start_date + 4.days }
    end
  end

  factory :course do
    sequence(:name) { |n| "Project #{n}" }
    sequence(:faculty_id) { |n| n }
    sequence(:quarter_id) { |n| n }
    status "pending" # FIXME
    description { "a"*500 }
    expected_deliverables { "a"*500 } # FIXME
    prerequisites { "a"*500 }
    related_work { "a"*500 } # FIXME
    # `user`s should _not_ be allowed to create projects!
    association :faculty, factory: [:user, :faculty]

    trait :accepted do
      status { "accepted" } # FIXME
    end

    trait :published do
      status_published { true }
    end

    trait :accepted_and_published do
      accepted # FIXME
      published
    end

    trait :in_current_quarter do
      quarter_id { Quarter.current_quarter.id } # FIXME
    end
  end

  factory :bid do # FIXME

  end
  #   sequence(:student_id) { |n| n }
  #   sequence(:project_id) { |n| n }
  #   status "pending"
  #   information { "a"*500 }
  #   qualifications { "a"*500 }
  #   courses { "a"*500 }
  #   project
  #   # `user`s should _not_ be allowed to create submissions!
  #   association :student, factory: [:user, :student]
  # end

end
