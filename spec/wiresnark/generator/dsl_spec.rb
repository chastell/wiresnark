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

  describe '#destination_ip' do

    it 'allows setting and reading destination IP address, defaulting to 0.0.0.0' do
      @env.destination_ip.should == '0.0.0.0'
      @env.destination_ip '1.2.3.4'
      @env.destination_ip.should == '1.2.3.4'
    end

  end

  describe '#destination_mac' do

    it 'allows setting and reading destination MAC address, defaulting to 00:00:00:00:00' do
      @env.destination_mac.should == '00:00:00:00:00:00'
      @env.destination_mac '11:22:33:44:55:66'
      @env.destination_mac.should == '11:22:33:44:55:66'
    end

  end

  describe '#payload' do

    it 'allows setting and reading payload, defaulting to empty' do
      @env.payload.should == ''
      @env.payload 'LOAD "*",8,1'
      @env.payload.should == 'LOAD "*",8,1'
    end

  end

  describe '#source_ip' do

    it 'allows setting and reading source IP address, defaulting to 0.0.0.0' do
      @env.source_ip.should == '0.0.0.0'
      @env.source_ip '1.2.3.4'
      @env.source_ip.should == '1.2.3.4'
    end

  end

  describe '#source_mac' do

    it 'allows setting and reading source MAC address, defaulting to 00:00:00:00:00' do
      @env.source_mac.should == '00:00:00:00:00:00'
      @env.source_mac '11:22:33:44:55:66'
      @env.source_mac.should == '11:22:33:44:55:66'
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
