class AddPublishedToAcademicYears < ActiveRecord::Migration
  def change
    add_column :academic_years, :published, :boolean, default: false, null: false
  end
end
