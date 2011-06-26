module Wiresnark describe DSL do

  describe '.send_packets_to' do

    # FIXME: unmock the below once implemented
    it 'sends the desired packets to the given interface' do
      packet_spec = -> {}
      Generator.should_receive(:generate).with(&packet_spec).and_return packets = mock
      Interfaces.should_receive(:[]).with('lo').and_return lo = mock
      lo.should_receive(:inject).with packets
      DSL.send_packets_to 'lo', &packet_spec
    end

  end

end end
