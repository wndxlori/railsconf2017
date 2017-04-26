class MainActivity < Android::Support::V7::App::AppCompatActivity
  include SwapiApp

  def onCreate(savedInstanceState)
    super
    UI.context = self
    @application = self.start_app
  end

  def onBackPressed
    if UI.context.getFragmentManager.getBackStackEntryCount == 0
      super
    else
      @application.navigation.pop
    end
  end
end
