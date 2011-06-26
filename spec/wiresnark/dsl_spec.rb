module Wiresnark describe DSL do

  describe '.send_packets_to' do

    it 'sends the desired packets to the given interface' do
      iface_name = 'DSL.send_packets_to spec interface'
      Interfaces[iface_name].should_receive(:inject).with([Packet.new(type: 'TCP'), Packet.new(type: 'TCP')])

      DSL.send_packets_to iface_name do
        count 2
        type 'TCP'
      end
    end

  end

end end
