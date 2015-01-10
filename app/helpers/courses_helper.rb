module CoursesHelper
  def edit_change_type
    @course.draft? ? "create" : "edit"
  end

  def form_preference
    @bid.new_record? ? "No preference" : @bid.preference
  end
end
