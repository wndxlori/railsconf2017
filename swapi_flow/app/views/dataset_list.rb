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
