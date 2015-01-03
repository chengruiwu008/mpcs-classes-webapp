class MakeCoursesDraftDefaultFalse < ActiveRecord::Migration
  def change
    change_column :courses, :draft, :boolean, default: false, null: false
  end
end
