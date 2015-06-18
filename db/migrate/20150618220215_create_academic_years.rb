class CreateAcademicYears < ActiveRecord::Migration
  def change
    create_table :academic_years do |t|
      t.string :start_year
      t.integer :year

      t.timestamps
    end
  end
end
