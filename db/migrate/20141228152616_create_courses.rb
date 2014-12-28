class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :title
      t.integer :instructor_id
      t.text :syllabus
      t.integer :number
      t.text :prerequisites
      t.text :time
      t.text :location

      t.timestamps
    end
  end
end
