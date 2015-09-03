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

  # student_summary_info: Returns the number of students who ranked this course
  # among their top N choices, where N is the number of courses they're taking
  # in this course's quarter.
  #
  # For every student who has bids that are in this course's quarter, check
  # whether that student's top N choices include this course.
  #
  # The total number of students (denominator) is the number who have submitted
  # submitted bids for courses in this course's quarter.
  #
  def student_summary_info
    tp = 0
    ts = 0

    Student.all.each do |s|
      top_courses = s.number_of_courses
      count_student = false

      s.bids.each do |b|
        if b.quarter_id == self.quarter_id
          count_student = true
          tp += 1 if (b.course_id == self.id && b.preference <= top_courses)
        end
      end

      ts += 1 if count_student
    end

    { :picks => tp, :students => ts }
  end

  def total_top_picks
    student_summary_info[:picks]
  end

  def number_of_students
    student_summary_info[:students]
  end

end
