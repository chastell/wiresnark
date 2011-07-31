module Wiresnark describe DSL do

  describe '.expect_packets_at' do

    it 'catches Packets on the given interface and sends the spec for comparison' do
      iface_name = 'DSL.expect_packets_at spec interface'
      Interface.new(iface_name).should_receive(:expect).with [Packet.new(type: 'TCP'), Packet.new(type: 'TCP')]

      DSL.expect_packets_at iface_name do
        count 2
        type 'TCP'
      end
    end

  end

  describe '.send_packets_to' do

    it 'sends the desired packets to the given interface' do
      iface_name = 'DSL.send_packets_to spec interface'
      Interface.new(iface_name).should_receive(:inject).with [Packet.new(type: 'TCP'), Packet.new(type: 'TCP')]

      DSL.send_packets_to iface_name do
        count 2
        type 'TCP'
      end
    end

  end

end end
