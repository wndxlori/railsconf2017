class FilmsScreen < PM::DataTableScreen
  title "Movies"
  stylesheet FilmsScreenStylesheet
  model Film, scope: :episode

  def on_load
  end

  # Remove the following if you're only using portrait
  def will_animate_rotate(orientation, duration)
    reapply_styles
  end

  def show(args={})
    open FilmScreen.new(navbar: true, episode_id: args[:episode_id])
  end
end
