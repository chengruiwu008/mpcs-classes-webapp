class ModifyAcademicYearsTable < ActiveRecord::Migration
  def change
    remove_column :academic_years, :start_year
    add_index :academic_years, :year, unique: true
  end
end
