class AppDelegate
  attr_accessor :window
  include SwapiApp

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    self.start_app
  end
end
