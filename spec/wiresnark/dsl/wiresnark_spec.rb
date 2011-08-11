module Wiresnark describe DSL::Wiresnark do

  before do
    @env = Object.new.extend DSL::Wiresnark
  end

  describe '#expect_packets_at, #expect_packets_at_blocks' do

    it 'stores the interface + expectation info in the extended Object' do
      Pcap.should_receive :open_live

      spec_a  = Proc.new { count 2; type 'Eth' }
      spec_b  = Proc.new { count 3; type 'QoS' }

      @env.expect_packets_at 'lo', &spec_a
      @env.expect_packets_at 'lo', &spec_b

      @env.expect_packets_at_blocks.should == [
        { interface: Interface.new('lo'), packet_spec: spec_a },
        { interface: Interface.new('lo'), packet_spec: spec_b },
      ]
    end

  end

  describe '#send_cycle_to, #send_cycle_to_blocks' do

    it 'stores the interface + generation info in the extended Object' do
      Pcap.should_receive :open_live

      spec_a  = Proc.new { phase_usec 200; types 'QoS', 'CAN', 'DSS', 'MGT' }
      spec_b  = Proc.new { phase_usec 100; types 'Eth' }

      @env.send_cycle_to 'lo', &spec_a
      @env.send_cycle_to 'lo', &spec_b

      @env.send_cycle_to_blocks.should == [
        { interface: Interface.new('lo'), packet_spec: spec_a },
        { interface: Interface.new('lo'), packet_spec: spec_b },
      ]
    end

  end

  describe '#send_packets_to, #send_packets_to_blocks' do

    it 'stores the interface + generation info in the extended Object' do
      Pcap.should_receive :open_live

      spec_a  = Proc.new { count 2; type 'Eth' }
      spec_b  = Proc.new { count 3; type 'QoS' }

      @env.send_packets_to 'lo', &spec_a
      @env.send_packets_to 'lo', &spec_b

      @env.send_packets_to_blocks.should == [
        { interface: Interface.new('lo'), packet_spec: spec_a },
        { interface: Interface.new('lo'), packet_spec: spec_b },
      ]
    end

  end

  describe '#verbose, #verbose?' do

    it 'sets verbose flag to true (default: false) and allows reading it' do
      env = Object.new.extend DSL::Wiresnark
      env.should_not be_verbose
      env.verbose
      env.should be_verbose
    end

  end

end end
