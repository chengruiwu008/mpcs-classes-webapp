module CoursesHelper
  def edit_change_type
    @course.draft? ? "create" : "edit"
  end
end
