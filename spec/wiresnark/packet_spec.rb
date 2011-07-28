module Wiresnark describe Packet do

  describe '.new' do

    it 'sets sane defaults' do
      Packet.new.destination_ip.should   == '0.0.0.0'
      Packet.new.destination_ipv6.should == '0000:0000:0000:0000:0000:0000:0000:0000'
      Packet.new.destination_mac.should  == '00:00:00:00:00:00'
      Packet.new.iip_byte.should         == 1
      Packet.new.payload.should          == ''
      Packet.new.source_ip.should        == '0.0.0.0'
      Packet.new.source_ipv6.should      == '0000:0000:0000:0000:0000:0000:0000:0000'
      Packet.new.source_mac.should       == '00:00:00:00:00:00'
      Packet.new.type.should             == 'Eth'
    end

  end

  describe '#==' do

    it 'tests equality' do
      Packet.new.should                  == Packet.new(type: 'Eth', payload: '')
      Packet.new(type: 'Eth').should_not == Packet.new(type: 'TCP')
      Packet.new(type: 'Eth').should_not == Packet.new(type: 'Eth', payload: 'foo')
    end

  end

  describe '#eql?' do

    it 'matches #== for equality' do
      Packet.new.should                  be_eql Packet.new(type: 'Eth', payload: '')
      Packet.new(type: 'Eth').should_not be_eql Packet.new(type: 'TCP')
      Packet.new(type: 'Eth').should_not be_eql Packet.new(type: 'Eth', payload: 'foo')
    end

  end

  describe '#hash' do

    it 'returns the same hash for eql? Packets' do
      Packet.new.hash.should == Packet.new(type: 'Eth', payload: '').hash
    end

  end

  describe '#{params}' do

    it 'returns the various param values' do
      Packet.new.type.should              == 'Eth'
      Packet.new(type: 'TCP').type.should == 'TCP'
      Packet.new.payload.should                 == ''
      Packet.new(payload: 'foo').payload.should == 'foo'
    end

  end

end end
