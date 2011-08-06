module Wiresnark module Generator

  describe '.generate' do

    it 'returns an Array of Packets (one Eth packet by default)' do
      Generator.generate {}.should == [Packet.new]
    end

    it 'makes it possible to set the count in the passed block' do
      Generator.generate { count 3 }.should == [Packet.new, Packet.new, Packet.new]
    end

    it 'makes it possible to set the type in the passed block' do
      Generator.generate { type 'IIP 1' }.should == [Packet.new(type: 'IIP 1')]
    end

    it 'resets on every generation' do
      Generator.generate { count 2; type 'IIP 1' }.should == [Packet.new(type: 'IIP 1'), Packet.new(type: 'IIP 1')]
      Generator.generate {}.should == [Packet.new]
    end

  end

end end
