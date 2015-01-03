class AddDraftToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :draft, :boolean
  end
end
