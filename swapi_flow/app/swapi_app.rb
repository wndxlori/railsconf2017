module SwapiApp

  def start_app
    screen = MainScreen.new
    navigation = UI::Navigation.new(screen)
    flow_app = UI::Application.new(navigation, self)
    flow_app.start
    flow_app
  end
end