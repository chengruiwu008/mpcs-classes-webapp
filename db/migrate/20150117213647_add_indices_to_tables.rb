class AddIndicesToTables < ActiveRecord::Migration
  def change
    add_index :bids, :student_id
    add_index :bids, :course_id
    add_index :bids, :quarter_id

    add_index :courses, :instructor_id
    add_index :courses, :quarter_id
  end
end
