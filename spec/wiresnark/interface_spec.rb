module Wiresnark describe Interface do

  describe '#inject' do

    it 'injects the passed Packets into the Interface' do
      iface_name = 'Interface#inject spec interface'

      inject = mock
      PacketFu::Inject.should_receive(:new).with(iface_name).and_return inject
      inject.should_receive(:inject).with array: ["\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00foo", "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00bar"]

      Interface.new(iface_name).inject [Packet.new(payload: 'foo'), Packet.new(payload: 'bar')]
    end

  end

end end
