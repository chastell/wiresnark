module Wiresnark describe Packet do

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
