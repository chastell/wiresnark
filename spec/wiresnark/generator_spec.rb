module Wiresnark module Generator

  describe '.generate' do

    it 'returns an Array of Packets (one Eth packet by default)' do
      Generator.generate {}.should == [Packet.new]
    end

    it 'makes it possible to set the count in the passed block' do
      Generator.generate { count 3 }.should == [Packet.new, Packet.new, Packet.new]
    end

    it 'makes it possible to set the type in the passed block' do
      Generator.generate { type 'TCP' }.should == [Packet.new(type: 'TCP')]
    end

    it 'resets on every generation' do
      Generator.generate { count 2; type 'IPv6' }.should == [Packet.new(type: 'IPv6'), Packet.new(type: 'IPv6')]
      Generator.generate {}.should == [Packet.new]
    end

  end

end end
