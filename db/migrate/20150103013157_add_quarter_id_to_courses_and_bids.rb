class AddQuarterIdToCoursesAndBids < ActiveRecord::Migration
  def change
    add_column :courses, :quarter_id, :integer
    add_column :bids, :quarter_id, :integer
  end
end
