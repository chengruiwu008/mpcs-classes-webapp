class Course < ActiveRecord::Base

  default_scope { order('courses.created_at DESC') }

  belongs_to :quarter
  belongs_to :instructor, class_name: "Faculty", foreign_key: "instructor_id"

  validates :title, presence: true, uniqueness: { scope: :quarter_id,
                                                  case_sensitive: false }
  validates :number, presence: true
  validates :syllabus, presence: true
  validates :instructor, presence: true
  validates :quarter, presence: true

end
