module CoursesHelper
  def edit_change_type
    @course.draft? ? "create" : "edit"
  end

  def form_preference
    @bid.new_record? ? "No preference" : @bid.preference
  end

  def formatted_title(course)
    @course.title + (@course.draft? ? " (Draft)" : "")
  end
end
