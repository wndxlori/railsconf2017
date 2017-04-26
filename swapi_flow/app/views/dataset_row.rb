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