class AddWebsiteAndSatisfiesToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :website, :string
    add_column :courses, :satisfies, :string
  end
end
