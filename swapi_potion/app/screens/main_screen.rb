class MainScreen < PM::TableScreen
  title "Star Wars - API"
  stylesheet MainScreenStylesheet
  searchable placeholder: "Search datasets", no_results: "Sorry, Try Again!"
  SWAPI_DATASETS = %w( films people planets species starships vehicles )

  def on_load
  end
  
  def table_data
    [{
      title: 'Datasets',
      cells: SWAPI_DATASETS.map do |set|
        { title: set.titleize, action: :select_dataset, arguments: {dataset: set}, accessory_type: :disclosure_indicator }
      end
    }]
  end
  
  def select_dataset(args={})
    case args[:dataset]
      when 'films'
        open FilmsScreen.new(navbar: true)
      when 'people'
        open PeopleScreen.new(navbar: true)
    end
  end

  # Remove the following if you're only using portrait
  def will_animate_rotate(orientation, duration)
    reapply_styles
  end
end
