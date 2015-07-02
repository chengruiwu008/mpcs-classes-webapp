class AcademicYear < ActiveRecord::Base

  # Has at most four quarters
  has_many :quarters

  # An academic year has a start_year, which is stored internally, and for
  # presentation purposes, it has a display_year.

  # e.g., the year might be 2015, in which case the display_year would be
  # "2015-2016".

  # This can be put into a helper.

  # create_table "academic_years", force: true do |t|
  #   t.string   "start_year"
  #   t.integer  "year"
  #   t.datetime "created_at"
  #   t.datetime "updated_at"
  # end

end
