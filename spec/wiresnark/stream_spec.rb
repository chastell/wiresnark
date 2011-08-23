require_relative '../spec_helper'

module Wiresnark describe Stream do

  describe '.for' do
    it 'returns the stream for the given interface and pcap lib' do
      pcap = MiniTest::Mock.new
      pcap.expect :open_live, [], ['lo', 0xffff, false, 0]
      Stream.for 'lo', pcap
      pcap.verify
    end

    it 'returns an empty Array if no lib specified' do
      Stream.for('lo').must_equal []
    end
  end

end end