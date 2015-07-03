class AddNotNullConstraintToYearQuartersAndAcademicYears < ActiveRecord::Migration
  def change
    change_column :academic_years, :year, :integer, null: false
    change_column :quarters, :year, :integer, null: false
  end
end
