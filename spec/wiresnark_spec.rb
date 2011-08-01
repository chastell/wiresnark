# encoding: UTF-8

module Wiresnark describe Wiresnark do

  describe '.run' do

    it 'setups Interfaces to listen and generate as per passed block' do
      spec_a  = Proc.new { count 2; type 'TCP' }
      spec_b  = Proc.new { count 3; type 'IP'  }

      Interface.new('lo').should_receive(:expect).with Generator.generate &spec_a
      Interface.new('lo').should_receive(:inject).with Generator.generate &spec_b

      Wiresnark.run do
        expect_packets_at 'lo', &spec_a
        send_packets_to   'lo', &spec_b
      end
    end

  end

end end
