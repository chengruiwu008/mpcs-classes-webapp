class Course < ActiveRecord::Base

  belongs_to :quarter
  belongs_to :faculty

end
