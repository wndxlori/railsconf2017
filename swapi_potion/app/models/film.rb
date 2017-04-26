class Film < CDQManagedObject
  scope :released, sort_by(:release_date)
  scope :episode, sort_by(:episode_id)

  def cell
    {
        title: title,
        subtitle: "Directed by #{director}",
        action: :show,
        arguments: {episode_id: episode_id},
        accessory_type: :disclosure_indicator,
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
