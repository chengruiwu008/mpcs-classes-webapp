class Bid < ActiveRecord::Base

  belongs_to :quarter
  belongs_to :student
  belongs_to :course

end
