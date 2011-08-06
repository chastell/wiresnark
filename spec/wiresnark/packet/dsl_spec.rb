module Wiresnark describe Packet::DSL do

  before do
    @env = Object.new.extend Packet::DSL
  end

  describe '#count' do

    it 'allows setting and reading packet count, defaulting to 1' do
      @env.count.should == 1
      @env.count 7
      @env.count.should == 7
    end

  end

  describe '#params' do

    it 'allows reading the current state of params' do
      @env.payload 'LOAD "*",8,1'
      @env.params[:payload].should == 'LOAD "*",8,1'
    end

  end

  describe '#{params}' do

    it 'allows setting the relevant params' do
      @env.destination_mac '11:22:33:44:55:66'
      @env.params[:destination_mac].should == '11:22:33:44:55:66'

      @env.payload 'LOAD "*",8,1'
      @env.params[:payload].should == 'LOAD "*",8,1'

      @env.source_mac '11:22:33:44:55:66'
      @env.params[:source_mac].should == '11:22:33:44:55:66'

      @env.type 'IIP'
      @env.params[:type].should == 'IIP'
    end

  end

end end
