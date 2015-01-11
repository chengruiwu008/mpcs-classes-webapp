class ChangeDefaultNumberOfCoursesUsers < ActiveRecord::Migration
  def change
    change_column :users, :number_of_courses, :integer, default: 2, null: false
  end
end
