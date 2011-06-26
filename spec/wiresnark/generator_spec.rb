module Wiresnark module Generator

  describe '.generate' do

    it 'returns an Array of Packets (one Eth packet by default)' do
      Packet.should_receive(:new).once.with(type: 'Eth').and_return packet = mock
      Generator.generate {}.should == [packet]
    end

    it 'makes it possible to set the count in the passed block' do
      Packet.should_receive(:new).exactly(3).times.and_return p1 = mock, p2 = mock, p3 = mock
      Generator.generate { count 3 }.should == [p1, p2, p3]
    end

    it 'resets the count on every generation' do
      Packet.should_receive(:new).twice
      Generator.generate { count 2 }
      Packet.should_receive(:new).once
      Generator.generate {}
    end

  end

end end
