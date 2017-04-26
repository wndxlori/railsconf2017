class FilmList  < UI::List
  def initialize
    super
    self.flex = 1
    render_row do
      FilmRow
    end
    load_films
  end

  def load_films
    self.data_source = Film.all
  end
end
