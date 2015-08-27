class AddCoursePrerequisitesToCoursesTable < ActiveRecord::Migration
  def change
    add_column :courses, :course_prerequisites, :text
  end
end
