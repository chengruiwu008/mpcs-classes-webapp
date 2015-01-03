class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.integer :student_id
      t.integer :course_id
      t.integer :preference

      t.timestamps
    end
  end
end
