require_relative '../spec_helper'

module Wiresnark describe Packet do
  describe '.new' do
    it 'creates an empty NIL packet by default' do
      Packet.new.to_bin.must_equal "\x00" * 12 + "\x08\x00" + "\x00" * 46
    end

    it 'creates a packet based on the passed Hash' do
      bin = "\xaa\xbb\xcc\xdd\xee\xff" + "\x11\x22\x33\x44\x55\x66" + "\x08\x00" + "\x02" + 'foo' + "\x00" * 82
      bin.force_encoding 'BINARY'
      Packet.new(
        destination_mac: 'aa:bb:cc:dd:ee:ff',
        min_size: 100,
        source_mac: '11:22:33:44:55:66',
        payload: 'foo',
        type: 'CAN',
      ).to_bin.must_equal bin
    end

    it 'creates packets of random sizes' do
      sizes = (1..100).map { Packet.new(random_size: 70..700).size }
      sizes.uniq.size.must_be :>, 1
      sizes.each { |size| (70..700).must_include size }
    end

    it 'creates a packet based on the passed binary String' do
      packet = Packet.new "\xaa\xbb\xcc\xdd\xee\xff" + "\x11\x22\x33\x44\x55\x66" + "\x08\x00" + "\x02" + 'foo' + "\x00" * 42
      packet.destination_mac.must_equal 'aa:bb:cc:dd:ee:ff'
      packet.source_mac.must_equal '11:22:33:44:55:66'
      packet.payload.must_equal 'foo' + "\x00" * 42
      packet.type.must_equal 'CAN'
    end
  end

  describe '#==' do
    it 'compares packets based on their binary representation' do
      Packet.new.must_equal Packet.new
      params = {
        destination_mac: 'aa:bb:cc:dd:ee:ff',
        source_mac: '11:22:33:44:55:66',
        payload: 'foo',
        type: 'CAN',
      }
      Packet.new(params).must_equal Packet.new params
    end
  end

  describe '#destination_mac' do
    it 'reads its destination MAC' do
      Packet.new.destination_mac.must_equal '00:00:00:00:00:00'
      Packet.new("\xaa\xbb\xcc\xdd\xee\xff" + "\x00" * 6 + "\x08\x00" + "\x00" * 46).destination_mac.must_equal 'aa:bb:cc:dd:ee:ff'
    end
  end

  describe '#destination_mac=' do
    it 'sets its destination MAC' do
      packet = Packet.new
      packet.destination_mac = 'aa:bb:cc:dd:ee:ff'
      bin = "\xaa\xbb\xcc\xdd\xee\xff".force_encoding 'BINARY'
      packet.to_bin[0..5].must_equal bin
    end
  end

  describe '#payload' do
    it 'reads its payload' do
      Packet.new.payload.must_equal "\x00" * 45
      Packet.new("\x00" * 12 + "\x08\x00" + "\x00" + 'foo' + "\x00" * 42).payload.must_equal 'foo' + "\x00" * 42
    end
  end

  describe '#payload=' do
    it 'sets its payload' do
      packet = Packet.new
      packet.payload = 'foo'
      packet.to_bin[15..-1].must_equal 'foo' + "\x00" * 42
    end

    it 'sets the payload even when it is bigger than 45 bytes' do
      packet = Packet.new
      packet.payload = 'foo' * 16
      packet.to_bin[15..-1].must_equal 'foo' * 16
    end

    it 'truncates the previous payload and pads the new one if needed' do
      packet = Packet.new
      packet.payload = 'foo' * 100
      packet.payload = 'bar' * 10
      packet.to_bin[15..-1].must_equal 'bar' * 10 + "\x00" * 270
    end

    it 'preserves the original size' do
      packet = Packet.new min_size: 100
      packet.payload = 'foo'
      packet.size.must_equal 100
    end
  end

  describe '#size' do
    it 'returns its size' do
      Packet.new.size.must_equal 60
      Packet.new(min_size: 100).size.must_equal 100
    end
  end

  describe '#source_mac' do
    it 'reads its source MAC' do
      Packet.new.source_mac.must_equal '00:00:00:00:00:00'
      Packet.new("\x00" * 6 + "\x11\x22\x33\x44\x55\x66" + "\x08\x00" + "\x00" * 46).source_mac.must_equal '11:22:33:44:55:66'
    end
  end

  describe '#source_mac=' do
    it 'sets its source MAC' do
      packet = Packet.new
      packet.source_mac = '11:22:33:44:55:66'
      packet.to_bin[6..11].must_equal "\x11\x22\x33\x44\x55\x66"
    end
  end

  describe '#to_s' do
    it 'returns a human-readable packet representation' do
      Packet.new.to_s.must_equal "NIL\t60\t[00:00:00:00:00:00] [00:00:00:00:00:00] [08.00] [00] [0000000000]"

      Packet.new(
        destination_mac: 'aa:bb:cc:dd:ee:ff',
        payload: 'foo',
        source_mac: '11:22:33:44:55:66',
        type: 'DSS',
      ).to_s.must_equal "DSS\t60\t[aa:bb:cc:dd:ee:ff] [11:22:33:44:55:66] [08.00] [01] [666f6f0000]"
    end
  end

  describe '#type' do
    it 'reads its type' do
      Packet.new.type.must_equal 'NIL'

      dss_bin = Packet.new.to_bin
      dss_bin[14] = "\x01"
      Packet.new(dss_bin).type.must_equal 'DSS'

      can_bin = Packet.new.to_bin
      can_bin[14] = "\x02"
      Packet.new(can_bin).type.must_equal 'CAN'

      qos_bin = Packet.new.to_bin
      qos_bin[14] = "\x04"
      Packet.new(qos_bin).type.must_equal 'QOS'

      mgt_bin = Packet.new.to_bin
      mgt_bin[14] = "\x07"
      Packet.new(mgt_bin).type.must_equal 'MGT'
    end
  end

  describe '#type=' do
    it 'sets its type, preserving payload on type changes (NIL -> non-NIL -> non-NIL -> NIL -> NIL)' do
      packet = Packet.new
      packet.payload = 'foo' * 10

      packet.type.must_equal 'NIL'
      packet.payload.must_equal 'foo' * 10 + "\x00" * 15

      packet.type = 'QOS'
      packet.type.must_equal 'QOS'
      packet.payload.must_equal 'foo' * 10 + "\x00" * 15

      packet.payload = 'foo' * 10
      packet.type.must_equal 'QOS'
      packet.payload.must_equal 'foo' * 10 + "\x00" * 15

      packet.type = 'DSS'
      packet.type.must_equal 'DSS'
      packet.payload.must_equal 'foo' * 10 + "\x00" * 15

      packet.type = 'NIL'
      packet.type.must_equal 'NIL'
      packet.payload.must_equal 'foo' * 10 + "\x00" * 15

      packet.type = 'NIL'
      packet.type.must_equal 'NIL'
      packet.payload.must_equal 'foo' * 10 + "\x00" * 15
    end
  end
end end
