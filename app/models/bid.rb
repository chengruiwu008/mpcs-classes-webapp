class Bid < ActiveRecord::Base

  default_scope { order('bids.created_at DESC') }

  belongs_to :quarter
  belongs_to :student
  belongs_to :course

  validates :student,    presence: true
  validates :course,     presence: true
  validates :quarter,    presence: true
  validates :preference, presence: true



end
