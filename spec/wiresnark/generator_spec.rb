module Wiresnark module Generator

  describe '.generate' do

    it 'returns an Array of Packets (one Eth packet by default)' do
      Packet.should_receive(:new).once.with(type: 'Eth').and_return packet = mock
      Generator.generate {}.should == [packet]
    end

  end

end end
