class MainScreen < UI::Screen
  attr_accessor :list

  def on_load
    self.list = DatasetList.new
    view.add_child(list)
    view.update_layout

    list.on(:select) {|data| select_screen(data) }
  end

  def before_on_show
    navigation.title = "Star Wars - API"
  end

  def select_screen(data)
    case data
      when 'films'
        navigation.push(FilmsScreen.new)
    end
  end
end