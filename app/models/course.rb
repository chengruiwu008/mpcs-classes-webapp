class Course < ActiveRecord::Base

  default_scope { order('courses.created_at DESC') }

  belongs_to :quarter
  belongs_to :instructor, class_name: "Faculty", foreign_key: "instructor_id"
  has_many :bids, dependent: :destroy
  accepts_nested_attributes_for :bids # Necessary?

  validates :title, uniqueness: { scope: :quarter_id,
                                  case_sensitive: false }
  validates :number, uniqueness: { scope: :quarter_id },
                     format: { with: /\A\d{5}\Z/,
                              message: "must be a five-digit number not " \
                               "beginning with 0" }
  validates :syllabus, presence: true
  validates :instructor, presence: true
  validates :quarter, presence: true

  def to_param
    number
  end

  # biddable?: Returns true if this course can be ranked by students, and false
  # if not. This course can be ranked if its quarter's bidding deadline has not
  # passed and the course is published.
  def biddable?
    published and !draft and DateTime.now <= quarter.student_bidding_deadline
  end

end
