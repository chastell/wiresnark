module Wiresnark describe DSL do

  before do
    @env = Object.new.extend DSL
  end

  describe '#expect_packets_at' do

    it 'stores the interface + expectation info in the extended Object' do
      iface_a = 'DSL#expect_packets_at spec interface A'
      iface_b = 'DSL#expect_packets_at spec interface B'

      spec_a  = Proc.new { count 2; type 'TCP' }
      spec_b  = Proc.new { count 3; type 'IP'  }

      @env.expect_packets_at iface_a, &spec_a
      @env.expect_packets_at iface_b, &spec_b

      @env.expectations.should == [
        { interface: Interface.new(iface_a), packet_spec: spec_a },
        { interface: Interface.new(iface_b), packet_spec: spec_b },
      ]
    end

  end

  describe '#send_packets_to' do

    it 'stores the interface + generation info in the extended Object' do
      iface_a = 'DSL#send_packets_to spec interface A'
      iface_b = 'DSL#send_packets_to spec interface B'

      spec_a  = Proc.new { count 2; type 'TCP' }
      spec_b  = Proc.new { count 3; type 'IP'  }

      @env.send_packets_to iface_a, &spec_a
      @env.send_packets_to iface_b, &spec_b

      @env.generations.should == [
        { interface: Interface.new(iface_a), packet_spec: spec_a },
        { interface: Interface.new(iface_b), packet_spec: spec_b },
      ]
    end

  end

end end
