class Quarter < ActiveRecord::Base

  default_scope { order('quarters.created_at DESC') }

  scope :active_quarters, -> {
    where("start_date <= ? AND ? <= end_date",
          DateTime.now, DateTime.now) }

  scope :active_quarter, -> {
    where("start_date <= ? AND ? <= end_date",
          DateTime.now, DateTime.now).take }

  has_many :courses

  validates :season, presence: true,
                     uniqueness: { scope:   :year,
                     message: "A quarter with that season and " +
                     "year already exists." },
                     inclusion:  { in:      %w(winter spring summer autumn),
                                   message: "Invalid quarter." }
  validates :year, presence: true, numericality: true, length: { is: 4 }

  validate :deadlines_between_start_and_end_dates

  before_validation :downcase_season


  def Quarter.deadlines
    [:start_date, :course_submission_deadline, :student_bidding_deadline,
     :end_date]
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

  def deadlines_between_start_and_end_dates
    message = "Deadlines must be between the quarter's start and end dates."
    if course_submission_deadline <= start_date or
      student_bidding_deadline <= start_date or
      end_date < course_submission_deadline or
      end_date < student_bidding_deadline
        errors.add(:base, message)
    end
  end

end
