class FilmScreen < PM::Screen
  attr_accessor :episode_id
  stylesheet FilmScreenStylesheet

  def on_load
    self.title = "Star Wars - Episode #{episode_id}"
    film = Film.where(:episode_id).eq(episode_id).first
    append(UILabel, :title_label).data(film.title)
    append(UILabel, :name_label).data(film.director)
    append(UILabel, :name_label).data(film.producer)
    append(UILabel, :date_label).data(film.release_date.to_date.to_formatted_s(:long))
    append(UITextView, :crawl_text).data(film.opening_crawl)
  end
  
  # Remove the following if you're only using portrait
  def will_animate_rotate(orientation, duration)
    reapply_styles
  end
end
