module Wiresnark describe Generator::DSL do

  before do
    @env = Object.new.extend Generator::DSL
  end

  describe '#count' do

    it 'allows setting and reading count, defaulting to 1' do
      @env.count.should == 1
      @env.count 7
      @env.count.should == 7
    end

  end

  describe '#type' do

    it 'allows setting and reading type, defaulting to Eth' do
      @env.type.should == 'Eth'
      @env.type 'TCP'
      @env.type.should == 'TCP'
    end

  end

end end
