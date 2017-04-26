class FilmRow < UI::ListRow
  attr_accessor :title_label
  attr_accessor :director_label

  def initialize
    self.padding = [10, 10, 10, 10]
    add_title_label
    add_director_label
  end

  def update(data)
    title_label.text = data['title']
    director_label.text = "Directed by #{data['director']}"
  end

  def add_director_label
    self.director_label = UI::Label.new
    add_child(director_label)
  end

  def add_title_label
    self.title_label = UI::Label.new
    add_child(title_label)
  end
end