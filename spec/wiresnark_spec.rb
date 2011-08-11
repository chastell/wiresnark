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

  end

end end
