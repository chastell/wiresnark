module Wiresnark module Generator

  describe '.generate' do

    it 'returns an Array of Packets (one Eth packet by default)' do
      Generator.generate {}.should == [Packet.new]
    end

    it 'makes it possible to set the count in the passed block' do
      Generator.generate { count 3 }.should == [Packet.new, Packet.new, Packet.new]
    end

    it 'makes it possible to set the type in the passed block' do
      Generator.generate { type 'QoS' }.should == [Packet.new(type: 'QoS')]
    end

    it 'resets on every generation' do
      Generator.generate { count 2; type 'QoS' }.should == [Packet.new(type: 'QoS'), Packet.new(type: 'QoS')]
      Generator.generate {}.should == [Packet.new]
    end

  end

  describe '.generate_for_cycle' do

    it 'returns a type-keyed Hash of Packets suitable to use in the described cycle' do
      Generator.generate_for_cycle do
        phase_usec  3
        phase_types 'Eth'
      end.should == {
        'Eth' => [Packet.new, Packet.new, Packet.new],
      }

      Generator.generate_for_cycle do
        phase_usec  2
        phase_types 'QoS', 'DSS'
      end.should == {
        'QoS' => [Packet.new(type: 'QoS'), Packet.new(type: 'QoS')],
        'DSS' => [Packet.new(type: 'DSS'), Packet.new(type: 'DSS')],
      }
    end

  end

end end
