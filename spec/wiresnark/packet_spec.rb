module Wiresnark describe Packet do

  describe '#==' do

    it 'tests type-based equality' do
      Packet.new(type: 'Eth').should     == Packet.new(type: 'Eth')
      Packet.new(type: 'Eth').should_not == Packet.new(type: 'TCP')
    end

  end

  describe '#eql?' do

    it 'matches #== for equality' do
      Packet.new(type: 'Eth').should     be_eql Packet.new(type: 'Eth')
      Packet.new(type: 'Eth').should_not be_eql Packet.new(type: 'TCP')
    end

  end

  describe '#hash' do

    it 'returns the same hash for eql? Packets' do
      Packet.new(type: 'Eth').hash.should == Packet.new(type: 'Eth').hash
    end

  end

end end
