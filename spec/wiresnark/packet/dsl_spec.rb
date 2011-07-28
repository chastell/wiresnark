module Wiresnark describe Packet::DSL do

  before do
    @env = Object.new.extend Packet::DSL
  end

  describe '#params' do

    it 'allows reading the current state of params, defaulting count to 1' do
      @env.params[:count].should == 1
      @env.count 7
      @env.payload 'LOAD "*",8,1'
      @env.params[:count].should   == 7
      @env.params[:payload].should == 'LOAD "*",8,1'
    end

  end

  describe '#{params}' do

    it 'allows setting the relevant params' do
      @env.count 7
      @env.params[:count].should == 7

      @env.destination_ip '1.2.3.4'
      @env.params[:destination_ip].should == '1.2.3.4'

      @env.destination_ipv6 '1111:2222:3333:4444:5555:6666:7777:8888'
      @env.params[:destination_ipv6].should == '1111:2222:3333:4444:5555:6666:7777:8888'

      @env.destination_mac '11:22:33:44:55:66'
      @env.params[:destination_mac].should == '11:22:33:44:55:66'

      @env.iip_byte 2
      @env.params[:iip_byte].should == 2

      @env.ip_id 0xbeef
      @env.params[:ip_id].should == 0xbeef

      @env.payload 'LOAD "*",8,1'
      @env.params[:payload].should == 'LOAD "*",8,1'

      @env.source_ip '1.2.3.4'
      @env.params[:source_ip].should == '1.2.3.4'

      @env.source_ipv6 '1111:2222:3333:4444:5555:6666:7777:8888'
      @env.params[:source_ipv6].should == '1111:2222:3333:4444:5555:6666:7777:8888'

      @env.source_mac '11:22:33:44:55:66'
      @env.params[:source_mac].should == '11:22:33:44:55:66'

      @env.type 'TCP'
      @env.params[:type].should == 'TCP'
    end

  end

end end
