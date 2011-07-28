module Wiresnark describe Generator::DSL do

  before do
    @env = Object.new.extend Generator::DSL
  end

  describe '#count' do

    it 'allows setting count, defaulting to 1' do
      @env.params[:count].should == 1
      @env.count 7
      @env.params[:count].should == 7
    end

  end

  describe '#destination_ip' do

    it 'allows setting destination IP address' do
      @env.destination_ip '1.2.3.4'
      @env.params[:destination_ip].should == '1.2.3.4'
    end

  end

  describe '#destination_ipv6' do

    it 'allows setting destination IPv6 address' do
      @env.destination_ipv6 '1111:2222:3333:4444:5555:6666:7777:8888'
      @env.params[:destination_ipv6].should == '1111:2222:3333:4444:5555:6666:7777:8888'
    end

  end

  describe '#destination_mac' do

    it 'allows setting destination MAC address' do
      @env.destination_mac '11:22:33:44:55:66'
      @env.params[:destination_mac].should == '11:22:33:44:55:66'
    end

  end

  describe '#iip_byte' do

    it 'allows setting IIP byte' do
      @env.iip_byte 2
      @env.params[:iip_byte].should == 2
    end

  end

  describe '#params' do

    it 'allows reading the current state of params' do
      @env.count 7
      @env.payload 'LOAD "*",8,1'
      @env.params[:count].should   == 7
      @env.params[:payload].should == 'LOAD "*",8,1'
    end

  end

  describe '#payload' do

    it 'allows setting payload' do
      @env.payload 'LOAD "*",8,1'
      @env.params[:payload].should == 'LOAD "*",8,1'
    end

  end

  describe '#source_ip' do

    it 'allows setting source IP address' do
      @env.source_ip '1.2.3.4'
      @env.params[:source_ip].should == '1.2.3.4'
    end

  end

  describe '#source_ipv6' do

    it 'allows setting source IPv6 address' do
      @env.source_ipv6 '1111:2222:3333:4444:5555:6666:7777:8888'
      @env.params[:source_ipv6].should == '1111:2222:3333:4444:5555:6666:7777:8888'
    end

  end

  describe '#source_mac' do

    it 'allows setting source MAC address' do
      @env.source_mac '11:22:33:44:55:66'
      @env.params[:source_mac].should == '11:22:33:44:55:66'
    end

  end

  describe '#type' do

    it 'allows setting type, defaulting to Eth' do
      @env.params[:type].should == 'Eth'
      @env.type 'TCP'
      @env.params[:type].should == 'TCP'
    end

  end

end end
