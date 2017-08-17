# RubyMotion for Rails Developers Workshop

These example apps display data that was sourced from the [Star Wars API](http://swapi.co)

## RedPotion App

Complete source for the `swapi_potion` app found at:

[RubyMotion for Rails Developers - RailsConf 2017](https://github.com/wndxlori/railsconf2017)

- Make sure your redpotion gem(s) are installed


`$ gem install redpotion`

- Create the app (we are skipping AFMotion to avoid accessing the data source via the internet)


`$ potion new swapi_potion —skip-afmotion`

- Change to the app directory, and start the skeleton app


```
$ cd swap_potion
$ rake
```

- We are not using the default screen. Create a main screen that is a table screen

`potion g table_screen main_screen`

- Change the title of the table screen (in `app/screens/main_screen.rb`)

```ruby
title "Star Wars - API”
```
(Run rake and see what you have)

- add some table\_data.  Form of table data looks like:

{ title: group_name, cells: [{title: name, action: method, arguments: {stuff: here }}]}

```ruby
SWAPI_DATASETS = %w( films people planets species starships vehicles )
def table_data  
  [{
    title: 'Datasets’,
    cells: SWAPI_DATASETS.map do |set|
      { 
        title: set.titleize, 
        action: :select_dataset, 
        arguments: {dataset: set}, 
        accessory_type: :disclosure_indicator
      }
    end
  }]
end
```

Run rake

- You probably want those datasets to be sorted

```
SWAPI_DATASETS.sort.map
```
Run rake

- add searchable to the MainScreen

```ruby
searchable placeholder: "Search datasets", no_results: "Sorry, Try Again!"
```

Run rake.  Type stuff in to the search bar

- add action method for the table cells ( `action: :select_dataset`)

```
def select_dataset(args={})
  p args[:stuff]
end
```
Run rake.  See what prints in the REPL when you touch a table cell

- open a new screen for when dataset 'films' is selected

```ruby
def select_dataset(args={})
  case args[:dataset]
    when ‘films'
      open FilmsScreen.new(navbar: true)
    else
      puts 'Not implemented’
    end
  end
end
```

- add data class
  - copy data files to resources dir (see Github [repo](https://github.com/wndxlori/railsconf2017/tree/master/swapi_potion/resources) json files)
  - add entity Film schema (see [json schema file](https://github.com/wndxlori/railsconf2017/blob/master/swapi_potion/resources/sw-films-schema.json) for field/type details)
  - (Note, there's a [sweet gem](https://github.com/andrewhavens/redpotion-generators) with generators for some of this

```ruby
entity "Film” do
  string :title, optional: false
  integer32 :episode_id, optional: false 
  string :opening_crawl, optional: false 
  string :director, optional: false 
  string :producer, optional: false 
  datetime :release_date, optional: false 
  # Not doing relationships, sorry! 
  # "characters",  # "planets",  # "starships",  # "vehicles",  # "species", 
  string :url,  optional: false
end
```

  - add the model, then update the model class (app/models/film.rb)

`potion g model film`

```ruby
class Film < CDQManagedObject
  scope :released, sort_by(:release_date)
  def cell
    {
      title: title,
      subtitle: "Directed by #{director}",
    }
  end
end
```

- use BubbleWrap to read in some data
  - add bubblewrap to your `Gemfile` and run `bundle`
  - create a load method

`gem "bubble-wrap"`  

```ruby
class Film < CDQManagedObject
  scope :released, sort_by(:release_date)
  def cell
    {
        title: title,
        subtitle: "Directed by #{director}",
    }
  end

  def self.load
    Film.all.each {|f| f.destroy }
    cdq.save
    path = NSBundle.mainBundle.pathForResource("sw-films", ofType:"json")
    films = BW::JSON.parse(NSData.dataWithContentsOfFile(path))
    films["results"].each do |raw|
      Film.create(
        title: raw["title"],
        episode_id: raw["episode_id"],
        opening_crawl: raw["opening_crawl"],
        director: raw["director"],
        producer: raw["producer"],
        release_date: NSDate.dateWithNaturalLanguageString(raw["release_date"]),
        url: raw["url"]
      )
    end
    cdq.save
  end

end
```

Run rake, then in the REPL run `Film.load` to populate your data.

- should probably get around to adding that `FilmsScreen` now

`potion g table_screen films_screen`

  - in your new screen (`app/screens/films_screen.rb`)
    - change type to `DataTableScreen`
    - remove table_data method
    - add your newly created model with default scope

```ruby
class FilmsScreen < PM::DataTableScreen
  title "Movies"
  stylesheet FilmsScreenStylesheet
  model Film, scope: :released

  def on_load
  end

  # Remove the following if you're only using portrait
  def will_animate_rotate(orientation, duration)
    reapply_styles
  end
end
```

Run rake.  Tap on 'films' from the dataset screen, and you should now see the list of films.

- Now we should have a film details screen. 
  - add an action (to the `cell` method in `Film` model, action method :show in screen `FilmsScreen) 

```ruby
def cell  
  {
    title: title,
    subtitle: "Directed by #{director}",
    action: :show,
    arguments: {episode_id: episode_id}
  }
end

def show(args={})
  open( FilmScreen.new(episode_id: args[:episode_id]))
end
```

- add that new details screen `FilmScreen`
  - add accessor for episode_id
  - remove default title
  - fill in the on_load with all the film details 

`potion g screen film_screen`

```ruby
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
```

- We cheated back there. Using styles (`:title_label, :name_label`, etc) that don't yet exist
  - add those styles to the stylesheet (`app/stylesheets/film_screen_style_sheet.rb`)
  - seriously appreciate the frame specifications of `'from_right', 'below_prev', and 'from_bottom' (fb)` 

```ruby
def title_label(st)
  st.font = font.system(24)
  st.frame = { top: 100, left: 20, from_right: 20, height: 40}
end
def name_label(st)
  st.frame = { below_prev: 10, left: 20, fr: 20, height: 30}
end
def date_label(st)
  st.frame = { bp: 10, left: 20, fr: 20, height: 30}
end
def crawl_text(st)
  st.frame = { bp: 10, left: 20, fr: 20, fb: 20}
end
```

Ok, now run rake and navigate from the dataset screen, to the films, to the film details.  

- Repeat the above steps for each of the datasets as an exercise on your own.  You'll find the beginnings of the People/Persons in the repo.



