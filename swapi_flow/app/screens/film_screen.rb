class FilmScreen < UI::Screen
  attr_accessor :film

  def initialize(film)
    self.film = film
  end

  def on_load
    background_view = UI::View.new.tap do |bg|
      bg.flex = 1
      bg.margin = 25
      bg.background_color = :white
    end
    %w( title director producer release_date).each do |field|
      background_view.add_child(create_label(field))
    end
#    background_view.add_child(create_crawl)
    self.view.add_child( background_view )
    self.view.update_layout
  end

  def before_on_show
    navigation.title = "Episode #{film['episode_id']}"
  end

  def create_label(field)
    UI::Label.new.tap do |label|
      label.flex_direction = :row
      label.flex = 1
      label.margin = [10, 15]
      label.padding = 5
      label.text = film[field]
    end
  end

  # def create_crawl
  #   UI::Text.new.tap do |uitext|
  #     uitext.flex = 1
  #     uitext.margin = [10, 15]
  #     uitext.padding = 5
  #     uitext.text = film['opening_crawl']
  #   end
  # end
end