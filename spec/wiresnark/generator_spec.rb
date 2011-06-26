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

    it 'makes it possible to set the type in the passed block' do
      Packet.should_receive(:new).with(type: 'TCP').and_return packet = mock
      Generator.generate { type 'TCP' }.should == [packet]
    end

    it 'resets on every generation' do
      Packet.should_receive(:new).twice.with type: 'IPv6'
      Generator.generate { count 2; type 'IPv6' }

      Packet.should_receive(:new).once.with type: 'Eth'
      Generator.generate {}
    end

  end

end end
