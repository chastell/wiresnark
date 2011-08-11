module Wiresnark describe DSL::Packet do

  before do
    @env = Object.new.extend DSL::Packet
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

  describe '#phase_usec' do

    it 'allows setting and reading phase lenght in microseconds, defaulting to 1000' do
      @env.phase_usec.should == 1000
      @env.phase_usec 200
      @env.phase_usec.should == 200
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

      @env.type 'QoS'
      @env.params[:type].should == 'QoS'
    end

  end

end end
