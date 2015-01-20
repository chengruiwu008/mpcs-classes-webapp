module QuarterPatterns

  def save(render_type)
    saved = (render_type == :new) ? "created" : "updated"

    if @quarter.update_attributes(quarter_params)
      flash[:success] = "Quarter successfully #{saved}."
      redirect_to quarters_path
    else
      flash.now[:error] = "Quarter could not be #{saved}."
      render render_type
    end
  end

end
