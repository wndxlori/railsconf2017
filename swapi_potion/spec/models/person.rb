describe 'Person' do

  before do
    class << self
      include CDQ
    end
    cdq.setup
  end

  after do
    cdq.reset!
  end

  it 'should be a Person entity' do
    Person.entity_description.name.should == 'Person'
  end
end
