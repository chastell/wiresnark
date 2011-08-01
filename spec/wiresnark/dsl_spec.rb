module Wiresnark describe DSL do

  before do
    @env = Object.new.extend DSL
  end

  describe '#expect_packets_at' do

    it 'stores the interface + expectation info in the extended Object' do
      spec_a  = Proc.new { count 2; type 'TCP' }
      spec_b  = Proc.new { count 3; type 'IP'  }

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
      spec_a  = Proc.new { count 2; type 'TCP' }
      spec_b  = Proc.new { count 3; type 'IP'  }

      @env.send_packets_to 'lo', &spec_a
      @env.send_packets_to 'lo', &spec_b

      @env.generations.should == [
        { interface: Interface.new('lo'), packet_spec: spec_a },
        { interface: Interface.new('lo'), packet_spec: spec_b },
      ]
    end

  end

end end
