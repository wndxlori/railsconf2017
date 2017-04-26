class FilmsScreen < UI::Screen
  attr_accessor :list

  def on_load
    self.list = FilmList.new
    view.add_child(list)
    view.update_layout

    list.on(:select) {|film| select_film(film)}
  end

  def before_on_show
    navigation.title = "Movies"
  end

  def select_film(film)
    navigation.push( FilmScreen.new(film) )
  end
end