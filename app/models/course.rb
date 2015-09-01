class Course < ActiveRecord::Base

  default_scope { order('title asc, courses.created_at DESC') }

  belongs_to :quarter
  belongs_to :instructor, class_name: "Faculty", foreign_key: "instructor_id"
  has_many   :bids, dependent: :destroy
  accepts_nested_attributes_for :bids # TODO: Necessary?

  validates :title, uniqueness: { scope: :quarter_id,
                                  case_sensitive: false }
  validates :number, uniqueness: { scope: :quarter_id },
                     format: { with: /\A\d{5}\Z/,
                              message: "must be a five-digit number not " \
                               "beginning with 0" }
  validates :syllabus, presence: true
  validates :quarter, presence: true

  def to_param
    number
  end

  # biddable?: Returns true if this course can be ranked by students, and false
  # if not. This course can be ranked if its quarter's bidding deadline has not
  # passed and the course is published.
  #
  def biddable?
    published and !draft and DateTime.now <= quarter.student_bidding_deadline
  end

  # total_top_picks: Returns the number of students who ranked this course
  # among their top N choices, where N is the number of courses they're taking
  # in this course's quarter.
  #
  # For every student who has bids that are in this course's quarter, check
  # whether that student's top N choices include this course.
  #
  # The total number of students (denominator) is the number who have submitted
  # submitted bids for courses in this course's quarter.
  #
  def total_top_picks
    total_top_picks = 0
    total_students = 0

    Student.all.each do |student|
      top_courses = student.number_of_courses
      count_student = false

      student.bids.each do |bid|
        if bid.quarter_id == self.quarter_id
          count_student = true

          if bid.course_id == self.id && bid.preference <= top_courses
            total_top_picks += 1
          end
        end
      end

      total_students += 1 if count_student
    end

    "#{total_top_picks} / #{total_students}"
  end

end
