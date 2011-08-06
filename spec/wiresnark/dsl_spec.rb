module Wiresnark describe DSL do

  before do
    @env = Object.new.extend DSL
  end

  describe '#expect_packets_at' do

    it 'stores the interface + expectation info in the extended Object' do
      spec_a  = Proc.new { count 2; type 'Eth' }
      spec_b  = Proc.new { count 3; type 'QoS' }

      @env.expect_packets_at 'lo', &spec_a
      @env.expect_packets_at 'lo', &spec_b

      @env.expectations.should == [
        { interface: Interface.new('lo'), packet_spec: spec_a },
        { interface: Interface.new('lo'), packet_spec: spec_b },
      ]
    end

  end

  describe '#send_packets_to' do

    it 'stores the interface + generation info in the extended Object' do
      spec_a  = Proc.new { count 2; type 'Eth' }
      spec_b  = Proc.new { count 3; type 'QoS' }

      @env.send_packets_to 'lo', &spec_a
      @env.send_packets_to 'lo', &spec_b

      @env.generations.should == [
        { interface: Interface.new('lo'), packet_spec: spec_a },
        { interface: Interface.new('lo'), packet_spec: spec_b },
      ]
    end

  end

  describe '#verbose, #verbose?' do

    it 'sets verbose flag to true (default: false) and allows reading it' do
      env = Object.new.extend DSL
      env.should_not be_verbose
      env.verbose
      env.should be_verbose
    end

  end

end end
