class Bid < ActiveRecord::Base

  default_scope { order('bids.created_at DESC') }

  belongs_to :quarter
  belongs_to :student
  belongs_to :course

  validates :student,    presence: true
  validates :course,     presence: true
  validates :quarter,    presence: true
  validates :preference, presence: true

  scope :quarter_bids, ->(quarter) { where(quarter_id: quarter.id) }

  def Bid.update_preferences(updated_bid)
    # Updates all bids for a user in a particular quarter, based on the
    # preference of the given (newly updated) bid. Ensures that no two
    # bids have the same preference.
    s_id = updated_bid.student_id
    q_id = updated_bid.quarter_id
    pref = updated_bid.preference
    bids = Bid.where(student_id: s_id, quarter_id: q_id)
    while bids.where(preference: pref).count > 1
      # Note: this assumes that the bid preferences unique before the
      # updated_bid was initially updated (before this function was called).
      bids.find_by(preference: pref).update_column(:preference, pref + 1)
      pref += 1
    end
  end

end
