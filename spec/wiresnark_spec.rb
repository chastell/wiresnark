# encoding: UTF-8

module Wiresnark describe Wiresnark do

  describe '.run' do

    it 'setups Interfaces to listen and generate as per passed block' do
      iface_a = 'Wiresnark.run spec interface A'
      iface_b = 'Wiresnark.run spec interface B'
      spec_a  = Proc.new { count 2; type 'TCP' }
      spec_b  = Proc.new { count 3; type 'IP'  }

      Interface.new(iface_a).should_receive(:expect).with Generator.generate &spec_a
      Interface.new(iface_b).should_receive(:inject).with Generator.generate &spec_b

      Wiresnark.run do
        expect_packets_at iface_a, &spec_a
        send_packets_to   iface_b, &spec_b
      end
    end

  end

end end
