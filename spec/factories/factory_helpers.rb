module FactoryHelpers
  # current_academic_year: not the same as `AcademicYear.current_year`!
  def current_academic_year
    y = Date.today.year
    DateTime.now < DateTime.new(y, 6, 21) ? y - 1 : y
  end
end

# As per http://stackoverflow.com/a/8271860
FactoryGirl::SyntaxRunner.send(:include, FactoryHelpers)
