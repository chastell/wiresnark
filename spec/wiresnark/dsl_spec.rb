module Wiresnark describe DSL do

  describe '.send_packets_to' do

    # FIXME: unmock the below once implemented
    it 'sends the desired packets to the given interface' do
      packet_spec = -> {}
      iface_name  = 'DSL.send_packets_to spec interface'

      Generator.should_receive(:generate).with(&packet_spec).and_return packets = mock
      Interfaces[iface_name].should_receive(:inject).with packets

      DSL.send_packets_to iface_name, &packet_spec
    end

  end

end end
