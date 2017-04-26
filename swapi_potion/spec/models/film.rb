describe 'Film' do

  before do
    class << self
      include CDQ
    end
    cdq.setup
  end

  after do
    cdq.reset!
  end

  it 'should be a Film entity' do
    Film.entity_description.name.should == 'Film'
  end
end
