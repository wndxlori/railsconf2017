class PeopleScreen < PM::DataTableScreen
  title "Characters"
  stylesheet PeopleScreenStylesheet
  model Person, scope: :by_name

  def on_load
  end
  
  def will_animate_rotate(orientation, duration)
    reapply_styles
  end
end
