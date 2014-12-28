class CreateQuarters < ActiveRecord::Migration
  def change
    create_table :quarters do |t|
      t.integer :year
      t.string :season
      t.datetime :start_date
      t.datetime :end_date
      t.datetime :course_submission_deadline
      t.datetime :student_bidding_deadline

      t.timestamps
    end
  end
end
