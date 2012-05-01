require_relative '../spec_helper'

module Wiresnark describe Interface do
  describe '#inject' do
    it 'injects the given packets to its stream' do
      stream = []
      Interface.new('lo', stream).inject [Packet.new, Packet.new]
      stream.must_equal [Packet.new.to_bin, Packet.new.to_bin]
    end

    it 'prints the injected packets to the output' do
      Interface.new('lo').inject [Packet.new(payload: 'foo'), Packet.new(payload: 'bar')], output = StringIO.new
      output.rewind
      output.read.must_equal <<-end.gsub(/^\s*/, '')
        -> lo\tNIL\t60\t[00:00:00:00:00:00] [00:00:00:00:00:00] [08.00] [00] [666f6f0000]
        -> lo\tNIL\t60\t[00:00:00:00:00:00] [00:00:00:00:00:00] [08.00] [00] [6261720000]
      end
    end
  end

  describe '#stream' do
    it 'returns the related stream' do
      stream = []
      lo = Interface.new 'lo', stream
      lo.stream.must_be_same_as stream
      lo.inject [Packet.new, Packet.new]
      lo.stream.must_equal [Packet.new.to_bin, Packet.new.to_bin]
    end
  end
end end
