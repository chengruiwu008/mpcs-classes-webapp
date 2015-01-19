module CoursePatterns

  def save(params, course, year, season, render_type)
    if params[:commit] == "Create this course"
      if course.save
        flash[:success] = "Course submitted."
        redirect_to my_courses_path(year: year, season: season)
      else
        render render_type
      end
    elsif params[:commit] == "Save as draft"
      course.assign_attributes(draft: true)
      if course.save
        flash[:success] = "Course information saved. You may edit it " +
          "by navigating to your \"my courses\" page."
        redirect_to my_courses_path(year: year, season: season)
      else
        render render_type
      end
    end
  end

end
