# encoding: UTF-8

module Wiresnark describe Wiresnark do

  describe '.run' do

    it 'setups Interfaces to listen and generate as per passed block' do
      spec_a  = Proc.new { count 2; type 'TCP' }
      spec_b  = Proc.new { count 3; type 'IP'  }

      Interface.new('lo').should_receive(:start_capture).ordered
      Interface.new('lo').should_receive(:inject).with(Generator.generate &spec_b).ordered
      Interface.new('lo').should_receive(:verify_capture).with(Generator.generate &spec_a).ordered

      Wiresnark.run do
        expect_packets_at 'lo', &spec_a
        send_packets_to   'lo', &spec_b
      end
    end

  end

end end
