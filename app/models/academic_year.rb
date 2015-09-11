class AcademicYear < ActiveRecord::Base

  validates_uniqueness_of :year
  validates_presence_of :year

  # Has at most four quarters (TODO: enforce this)
  # Careful when deleting years!
  has_many :quarters, dependent: :destroy, foreign_key: "year",
           primary_key: "year"

  def self.current_year
    (AcademicYear.select { |ay| ay.current? }).first
  end

  # self.form_select_hash: for the Quarter's new_edit_form.
  # Contains the years corresponding to the existing academic_year records.
  def self.form_select_hash
    h = Hash.new

    AcademicYear.all.each do |y|
      h[ApplicationController.helpers.formatted_year(y)] = y.year
    end

    Hash[h.sort]
  end

  # self.form_select_hash_possible: for creating a new academic_year.
  # Contains all possible years an academic_year could exhibit.
  def self.form_select_hash_possible
    h = Hash.new

    (Time.now.year - 5..Time.now.year + 5).each do |y|
      h[ApplicationController.helpers.formatted_year_from_int(y)] = y
    end

    Hash[h.sort]
  end

  # current?: an academic_year is current if the current date is between
  # its start date (the beginning of summer quarter during the first year)
  # and its end date (the end of spring quarter during the second year).
  def current?
    start_date = DateTime.new(self.year, 6, 21)
    # end_date should be one year after the start_date
    end_date   = DateTime.new(self.year + 1, 6, 20) # 21?

    start_date <= DateTime.now and DateTime.now <= end_date
  end

  # next_year: Returns the next academic year, if it exists.
  # If it does not exist, returns nil.
  def next_year
    AcademicYear.find_by(year: self.year + 1)
  end

  def to_param
    ApplicationController.helpers.year_slug(self.year)
  end

end
