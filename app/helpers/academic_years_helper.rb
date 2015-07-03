module AcademicYearsHelper

  def new_year_btn_class(change)
    btn_type = (change == "create" ? "success" : "primary")
    "btn btn-#{btn_type}"
  end

  def formatted_year(year)
    y = year.year
    "#{y}-#{y+1}"
  end

  def formatted_year_from_int(year_int)
    y = year_int
    "#{y}-#{y+1}"
  end

end
