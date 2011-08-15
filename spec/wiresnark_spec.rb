# encoding: UTF-8

module Wiresnark describe Wiresnark do

  describe '.run' do

    it 'setups Interfaces to inject and verify as per passed block' do
      Pcap.should_receive :open_live

      spec_a = Proc.new { count 2; type 'Eth' }
      spec_b = Proc.new { count 3; type 'QoS' }

      Interface.new('lo').should_receive(:inject).with(Generator.generate(&spec_b), $stdout).ordered
      Interface.new('lo').should_receive(:verify).with(Generator.generate(&spec_a), $stdout).ordered

      Wiresnark.run do
        verbose
        expect_packets_at 'lo', &spec_a
        send_packets_to   'lo', &spec_b
      end
    end

    it 'setups Interfaces to inject and verify as per passed file' do
      Pcap.should_receive :open_live

      Interface.new('lo').should_receive(:inject).ordered
      Interface.new('lo').should_receive(:verify).ordered

      Wiresnark.run 'spec/fixtures/ten-qos-to-lo.rb'
    end

    # it 'setups Interfaces to cycle as per passed block' do
    #   Pcap.should_receive :open_live

    #   spec = Proc.new do
    #     phase_usec  200
    #     phase_types 'QoS', 'CAN', 'DSS', 'MGT'
    #   end

    #   Generator.should_receive(:generate_for_cycle).with(&spec).and_return packets = mock

    #   Wiresnark.run do
    #     send_cycle_to 'lo', &spec
    #   end
    # end

  end

end end
