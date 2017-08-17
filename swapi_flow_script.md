# RubyMotion for Rails Developers Workshop

These example apps display data that was sourced from the [Star Wars API](http://swapi.co)

## Flow App

Complete source for the `swapi_flow` app found at:

[RubyMotion for Rails Developers - RailsConf 2017](https://github.com/wndxlori/railsconf2017)

- Make sure your flow gem(s) are installed


`$ gem install motion-flow`

- Create the app using the Flow template


```bash
$ motion create --template=flow swapi_flow
$ cd swapi_flow
```

- Create a module `swapi_app.rb` under `app` for the shared startup code

```ruby
module SwapiApp  
  def start_app
    screen = MainScreen.new
    navigation = UI::Navigation.new(screen)
    flow_app = UI::Application.new(navigation, self)
    flow_app.start
    flow_app
  end
end
```
- Replace the template generated Android `app/android/main_activity.rb` code with:

```ruby
class MainActivity < Android::Support::V7::App::AppCompatActivity
  include SwapiApp
  
  def onCreate(savedInstanceState)
    super
    UI.context = self
    @application = self.start_app
  end
end
```

- And the template generated iOS `app/ios/app_delegate.rb` with:

```ruby
class AppDelegate
  attr_accessor :window
  include SwapiApp
  
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @application = self.start_app
  end
end
```

- Create a directory under `app` for screens

```bash
$ mkdir app/screens
```

- Make that new `app/screens/main_screen.rb`

```ruby
class MainScreen < UI::Screen
  def on_load
    navigation.title = "Star Wars - API”
  end
end
```

- And run the app. Make sure you start the GenyMotion emulator before this

```bash
$ rake super_repl
```

You should see the app run simultaneously in the iOS Simulator and GenyMotion emulator. (Ok, it takes a lot longer in Android)

Next up, let's get that list added

- add a new list view in `MainScreen.on_load`

```ruby
view.add_child(DatasetList.new)
view.update_layout
```

- better create the new view `app/views/dataset_list.rb`

```bash
$ mkdir app/views
```
```ruby
class DatasetList  < UI::List

  def initialize
    super
    self.flex = 1
    render_row do
      DatasetRow
    end
    load_datasets
  end
  
  def load_datasets
    self.data_source = %w(films people planets species starships vehicles)
  end
end
```

- and that list needs a row `app/views/dataset_row.rb`

```ruby
class DatasetRow < UI::ListRow
  attr_accessor :title_label
  
  def initialize
    self.padding = [10, 10, 10, 10]
    add_title_label
  end
  
  def update(data)
    title_label.text = data
  end
  
  def add_title_label
    self.title_label = UI::Label.new
    add_child(title_label)
  end
end
```

Go ahead and run `rake super_repl` again, to see our newly populated main screen with it's list of datasets

Now let's add the list selection, and navigation to a new screen

- add list select to `MainScreen.on_load`

```ruby
self.list = DatasetList.new
view.add_child(list)
view.update_layout

list.on(:select) {|data| select_screen(data) }
```

- add the new `select_screen` method

```ruby
def select_screen(data)
  case data
    when ‘films'
      navigation.push(FilmsScreen.new)
  end
end
```

- now we need the new screen `app/screens/films_screen.rb`
  - copy `main_screen.rb` to `films_screen.rb`
  - change class name to `FilmsScreen`
  - change list to `FilmList`
  - change the data source to `Film.all` 

- need new views for our films too
  - copy `dataset_list.rb` to `film_list.rb`
  - change class name to `FilmList`
  - change row to `FilmRow`

- let's create a new class for `app/views/film_row.rb` since it's a bit different

```ruby
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
    director_label.text = "Directed by #{data['director']}”
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
```

And, we need to add a model `app/models/film.rb` to supply data for the FilmsScreen

```bash
$ mkdir models
```

```ruby
class Film
  def self.all
    @all ||= begin
      raw = self.load
    end
  end
  def self.load
    JSON.load(ResourceLoader.read_file('sw-films.json'))
  end
end
```

Unfortunately, while Flow does have the nice cross-platform JSON class, there (currently) is no cross-platform means of reading in resource files.  So, we'll just create one to read in our json files.

- under `app/ios` create `resource_loader.rb`

```ruby
class ResourceLoader
  def self.read_file(filename)
    parts = filename.split('.')
    path = NSBundle.mainBundle.pathForResource(parts.first, ofType:parts.last)
    NSData.dataWithContentsOfFile(path).to_str
  end
end
```

- under `app/android` create another `resource_loader.rb`

```ruby
class ResourceLoader
  def self.read_file(filename)
    is = UI.context.getAssets.open(filename)
    isr = Java::IO::InputStreamReader.new(is)
    br = Java::IO::BufferedReader.new(isr)
    buffer = ''
    while (str=br.readLine) do
      buffer.concat(str)
    end
    br.close; isr.close; is.close
    buffer
  end
end
```

Let's test loading from the super_repl

```bash
$ rake super_repl
```

```ruby
Film.load
```

You should see dual results, one from Android and one from iOS

Now I want to see those results sorted by release date

- in the `Film.all`, we should be returning the sorted 'results' from the json

```ruby
 raw['results'].sort {|a,b| a['release_date'] <=> b['release_date’]}
```

Run the super_repl again, and now you can navigate to your Films Screen.

Couple of problems, though.

1. We forgot to update the screen name in FilmsScreen.
2. Navigation in the Android app is wonky.  When we hit the back nav button (hard device button on Android), it dumps us out of the app.  How unexpected.

- Fix Android navigation, by making the MainActivity respond to the back button by adding `MainActivity.onBackPressed`

```ruby
def onBackPressed
  if UI.context.getFragmentManager.getBackStackEntryCount == 0
    super
  else
    @application.navigation.pop
  end
end
```

- Fix the title in `FilmsScreen.on_load`

```ruby
 navigation.title = “Movies"
```

Let's run super_repl and try that again.

Oh noes!  Now the back button works, but the navigation title does not update when we navigate back to the MainScreen.  The title is only being set when the view is loaded.  We can fix the title by deferring setting it to the `before_on_load` method.

- In `MainScreen.on_load`, remove the title line, and replace it with

```ruby
def before_on_show
  navigation.title = "Star Wars - API"
end
```

- In `FilmsScreen.on_load`, remove the title line, and replace it with

```ruby
def before_on_show
  navigation.title = “Movies"
end
```

Now, check your app in the super_repl, and you will see navigation works as one would expect in both the iOS and Android apps

One more screen!!!

- Add the details screen - `app/screens/film_screen.rb`
  - copy `films_screen.rb` to `film_screen.rb`

- add a film instance variable & initializer to set it

```ruby
attr_accessor :film

def initialize(film)
  self.film = film
end
```

Replace the contents of `on_load`.  We'll be using Flow's built-in support for [Flexbox](https://tympanus.net/codrops/css_reference/flexbox/#section_flex-direction) to manage layout in this screen and it's views.

- with a new custom background view

```ruby
background_view = UI::View.new.tap do |bg|
  bg.flex = 1
  bg.margin = 25
  bg.background_color = :white
end
```

- and labels to display additional content to `on_load`

```ruby
%w( title director producer release_date).each do |field|
  background_view.add_child(create_label(field))
end
self.view.add_child( background_view )
self.view.update_layout
```

- now add that `create_label` method

```ruby
def create_label(field)
  UI::Label.new.tap do |label|
    label.flex_direction = :row
    label.flex = 1
    label.margin = [10, 15]
    label.padding = 5
    label.text = film[field]
  end
end
```

And let's try that screen out.  Now the details for each film are available.  

One more little addition.  Let's add that opening crawl.  That's a lot more text, so we need the multi-line `UI::Text`

```ruby
# Add crawl to on_load
background_view.add_child(create_crawl)
```
```ruby
def create_crawl
  UI::Text.new.tap do |uitext|
    uitext.flex = 1
    uitext.margin = [10, 15]
    uitext.padding = 5
    uitext.text = film['opening_crawl']
  end
end
```

A fini!

