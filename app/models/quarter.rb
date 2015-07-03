class Quarter < ActiveRecord::Base

  default_scope { order('quarters.created_at DESC') }

  scope :active_quarters, -> {
    where("start_date <= ? AND ? <= end_date",
          DateTime.now, DateTime.now) }

  scope :future_quarters, -> { where("? < start_date", DateTime.now) }

  scope :can_add_courses, -> {
    Quarter.active_quarters.where("? <= course_submission_deadline",
                                  DateTime.now) }

  scope :open_for_bids, -> {
    Quarter.active_quarters.where("? <= student_bidding_deadline",
                                  DateTime.now) }

  belongs_to :academic_year, primary_key: "year", foreign_key: "year"
  has_many   :courses
  has_many   :bids

  validates :season, presence: true,
                     uniqueness: { scope:   :year,
                     message: "A quarter with that season and " +
                     "year already exists." },
                     inclusion:  { in:      %w(winter spring summer autumn),
                                   message: "Invalid quarter." }
  validates :year, presence: true, numericality: true, length: { is: 4 }
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :course_submission_deadline, presence: true
  validates :student_bidding_deadline, presence: true

  before_validation :downcase_season

  # visible_quarters: All published quarters in the current academic year.
  def self.visible_quarters
    Quarter.where(published: true).
     where(year: AcademicYear.current_year.year).to_a
  end

  def Quarter.years
    Course.all.map{ |c| c.quarter.year }.uniq
  end

  def Quarter.seasons
    Quarter.all.map{ |q| q.season.capitalize }.uniq
  end

  def Quarter.deadlines
    [:start_date, :course_submission_deadline, :student_bidding_deadline,
     :end_date]
  end

  def published_courses
    self.courses.where(published: true)
  end

  def Quarter.active_quarter
    Quarter.active_quarters.take
  end

  def deadline(deadline)
    self.send("#{deadline}_deadline".to_sym)
  end

  def active?
    (start_date <= DateTime.now) and (DateTime.now <= end_date)
  end

  def downcase_season
    self.season.downcase!
  end

end
