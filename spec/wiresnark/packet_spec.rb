module Wiresnark describe Packet do

  describe '#==' do

    it 'tests type-based equality' do
      Packet.new(type: 'Eth').should     == Packet.new(type: 'Eth')
      Packet.new(type: 'Eth').should_not == Packet.new(type: 'TCP')
    end

  end

end end
