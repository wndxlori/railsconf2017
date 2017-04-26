class ResourceLoader
  def self.read_file(filename)
    parts = filename.split('.')
    path = NSBundle.mainBundle.pathForResource(parts.first, ofType:parts.last)
    NSData.dataWithContentsOfFile(path).to_str
  end
end
