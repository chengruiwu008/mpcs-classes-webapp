module QuarterPatterns

  def save(render_type)
    saved = { new: "created", edit: "updated", index: "deleted" }[render_type]
    # If we're destroying the quarter, test @quarter.destroy below.
    # If we're not, test @quarter.update_attributes(quarter_params).
    f = (render_type == :index) ? :destroy : [:update_attributes,quarter_params]

    if @quarter.send(*f)
      flash[:success] = "Quarter successfully #{saved}."
      redirect_to quarters_path and return
    else
      flash.now[:error] = "Quarter could not be #{saved}."
      render render_type
    end
  end

end
