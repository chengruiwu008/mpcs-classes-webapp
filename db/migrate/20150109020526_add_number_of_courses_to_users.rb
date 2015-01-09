class AddNumberOfCoursesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :number_of_courses, :integer
  end
end
