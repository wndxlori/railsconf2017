class Person < CDQManagedObject
  scope :by_name, sort_by(:name)

  def cell
    {
        title: name,
        subtitle: "Homeworld: #{homeworld}"
    }
  end

  def self.load
    Person.all.each {|p| p.destroy }
    cdq.save
    path = NSBundle.mainBundle.pathForResource("sw-people", ofType:"json")
    people = BW::JSON.parse(NSData.dataWithContentsOfFile(path))
    people["results"].each do |raw|
      Person.create(
          name: raw["name"],
          height: raw["height"],
          mass: raw["mass"],
          hair_color: raw["hair_color"],
          skin_color: raw["skin_color"],
          eye_color: raw["eye_color"],
          birth_year: raw["birth_year"],
          gender: raw["gender"],
          homeworld: raw["homeworld"],
          url: raw["url"]
      )
    end
    cdq.save
  end
end
