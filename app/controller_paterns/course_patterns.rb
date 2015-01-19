module CoursePatterns

  def save(render_type)
    if params[:commit] == "Create this course"
      @course.assign_attributes(draft: false) if render_type == 'edit'
      if @course.save
        flash[:success] = "Course submitted."
        redirect_to my_courses_path(year: @year, season: @season)
      else
        render render_type
      end
    elsif params[:commit] == "Save as draft"
      @course.assign_attributes(draft: true) if render_type == 'new'
      if @course.save
        flash[:success] = "Course information saved. You may edit it " +
          "by navigating to your \"my courses\" page."
        redirect_to my_courses_path(year: @year, season: @season)
      else
        render render_type
      end
    end
  end

end
