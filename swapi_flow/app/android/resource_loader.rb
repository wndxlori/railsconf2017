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
