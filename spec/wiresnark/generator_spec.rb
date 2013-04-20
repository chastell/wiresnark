require_relative '../spec_helper'

module Wiresnark describe Generator do
  describe '.generate' do
    it 'generates packets based on the passed spec' do
      env = Object.new.extend DSL::GeneratorDSL
      env.instance_eval { count 3 }
      Generator.generate(env).must_equal [Packet.new, Packet.new, Packet.new]

      bin = "\xaa\xbb\xcc\xdd\xee\xff" + "\x11\x22\x33\x44\x55\x66" + "\x08\x00" + "\x02" + 'foo' + "\x00" * 42
      packet = Packet.new bin.force_encoding 'BINARY'
      env = Object.new.extend DSL::GeneratorDSL
      env.instance_eval do
        count 5
        destination_mac 'aa:bb:cc:dd:ee:ff'
        payload 'foo'
        source_mac '11:22:33:44:55:66'
        type 'CAN'
      end
      Generator.generate(env).must_equal [packet, packet, packet, packet, packet]
    end

    it 'generates the explicit number of packets (if present)' do
      env = Object.new.extend DSL::GeneratorDSL
      env.instance_eval { count 3 }
      Generator.generate(env, 2).must_equal [Packet.new, Packet.new]
    end

    it 'overrides payload with sequence (if requested)' do
      env = Object.new.extend DSL::GeneratorDSL
      env.instance_eval { count 3; sequence }
      Generator.generate(env).map(&:payload).must_equal ["\x00\x00\x00\x00\x00" + "\x00" * 40, "\x00\x00\x00\x00\x01" + "\x00" * 40, "\x00\x00\x00\x00\x02" + "\x00" * 40]
    end
  end
end end
