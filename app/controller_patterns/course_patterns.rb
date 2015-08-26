module CoursePatterns

  def save(render_type)
    if params[:commit] == "Create this course"
      @course.assign_attributes(draft: false) if render_type == 'edit'
      if @course.save
        flash[:success] = "Course submitted."
        redirect_to courses_path(year: year_slug(@year), season: @season)
      else
        render render_type
      end
    elsif params[:commit] == "Save as draft"
      @course.assign_attributes(draft: true) if render_type == 'new'
      if @course.save
        flash[:success] = "Course information saved. You may edit it " +
          "by navigating to the \"courses\" page."
        redirect_to courses_path(year: year_slug(@year), season: @season)
      else
        render render_type
      end
    end
  end

  def destroy_bid
    if @bid.destroy
      flash[:success] = "Successfully updated course preference."
      redirect_to q_path(@course) and return
    end
  end

  def create_or_update_bid(bid_params)
    if @bid.new_record?
      bid_params.merge!(quarter_id: @quarter.id, course_id: @course.id)
    end

    if @bid.update_attributes(bid_params)
      Bid.update_preferences(@bid)
      flash[:success] = "Successfully updated course preference."
      redirect_to q_path(@course) and return
    else
      flash[:error].now = "Unable to update course request."
      render 'show' and return
    end
  end

end
