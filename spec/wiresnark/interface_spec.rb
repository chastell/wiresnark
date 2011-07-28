module Wiresnark describe Interface do

  describe '#inject' do

    before do
      @iface_name = 'Interface#inject spec interface'
      PacketFu::Inject.should_receive(:new).with(@iface_name).and_return @injector = mock
    end

    it 'injects the passed Packets into the Interface' do
      @injector.should_receive(:inject).with array: ["\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00foo", "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00bar"]
      Interface.new(@iface_name).inject [Packet.new(payload: 'foo'), Packet.new(payload: 'bar')]
    end

    it 'puts the information about injected Packets to the passed IO' do
      @injector.should_receive :inject
      Interface.new(@iface_name).inject [Packet.new(payload: 'foo'), Packet.new(payload: 'bar')], output = StringIO.new
      output.rewind
      output.read.should == <<-END
injected into #{@iface_name}:
\tEth  00 00 00 00 00 00 00 00 00 00 00 00 08 00 66 6f 6f
\tEth  00 00 00 00 00 00 00 00 00 00 00 00 08 00 62 61 72
      END
    end

  end

end end
