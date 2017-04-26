class Film
  def self.all
    @all ||= begin
      raw = self.load
      raw['results'].sort {|a,b| a['release_date'] <=> b['release_date']}
    end
  end

  def self.load
    JSON.load(ResourceLoader.read_file('sw-films.json'))
  end
end