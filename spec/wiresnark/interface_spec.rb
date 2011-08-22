require_relative '../spec_helper'

module Wiresnark describe Interface do

  describe '.new' do
    it 'returns the same interface on subsequent calls' do
      Interface.new('foo').must_be_same_as Interface.new 'foo'
      Interface.new('foo').wont_be_same_as Interface.new 'bar'
    end

    it 'hooks to the inteface using the provided interface' do
      pcap = MiniTest::Mock.new
      pcap.expect :open_live, nil, ['lo', 0xffff, true, 0]
      Interface.new 'lo', pcap
      pcap.verify
    end
  end

end end
