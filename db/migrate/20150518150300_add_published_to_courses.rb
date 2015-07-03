class AddPublishedToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :published, :boolean, default: false, null: false
  end
end
