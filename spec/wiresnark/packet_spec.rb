module Wiresnark describe Packet do

  describe '.new' do

    it 'sets sane defaults' do
      Packet.new.destination_mac.should  == '00:00:00:00:00:00'
      Packet.new.payload.should          == ''
      Packet.new.source_mac.should       == '00:00:00:00:00:00'
      Packet.new.type.should             == 'Eth'
    end

    it 'creates Packet by parsing the passed binary' do
      Packet.new("\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00").should == Packet.new
      Packet.new("\xAA\xBB\xCC\xDD\xEE\xFF\x11\x22\x33\x44\x55\x66\x08\x00foo").should == Packet.new(
        source_mac:      '11:22:33:44:55:66',
        destination_mac: 'aa:bb:cc:dd:ee:ff',
        payload:         'foo',
      )
      Packet.new("\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x01foo").should == Packet.new(payload: 'foo', type: 'QoS')
      Packet.new("\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x02bar").should == Packet.new(payload: 'bar', type: 'CAN')
      Packet.new("\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x03baz").should == Packet.new(payload: 'baz', type: 'DSS')
      Packet.new("\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x04qux").should == Packet.new(payload: 'qux', type: 'MGT')
    end

    it 'properly creates IIP Packets' do
      Packet.new(payload: 'foo', type: 'QoS').to_bin.should == "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x01foo"
      Packet.new(payload: 'bar', type: 'CAN').to_bin.should == "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x02bar"
      Packet.new(payload: 'baz', type: 'DSS').to_bin.should == "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x03baz"
      Packet.new(payload: 'qux', type: 'MGT').to_bin.should == "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x04qux"
    end

  end

  describe '#==' do

    it 'tests equality' do
      Packet.new.should                  == Packet.new(type: 'Eth', payload: '')
      Packet.new(type: 'Eth').should_not == Packet.new(type: 'QoS')
      Packet.new(type: 'Eth').should_not == Packet.new(type: 'Eth', payload: 'foo')
    end

  end

  describe '#destination_mac' do

    it 'returns human-readable destination MAC' do
      Packet.new(destination_mac: 'aa:bb:cc:dd:ee:ff').destination_mac.should == 'aa:bb:cc:dd:ee:ff'
    end

  end

  describe '#eql?' do

    it 'matches #== for equality' do
      Packet.new.should                  be_eql Packet.new(type: 'Eth', payload: '')
      Packet.new(type: 'Eth').should_not be_eql Packet.new(type: 'QoS')
      Packet.new(type: 'Eth').should_not be_eql Packet.new(type: 'Eth', payload: 'foo')
    end

  end

  describe '#hash' do

    it 'returns the same hash for eql? Packets' do
      Packet.new.hash.should == Packet.new(type: 'Eth', payload: '').hash
    end

  end

  describe '#payload' do

    it 'returns payload, regardless of packet type' do
      Packet.new(payload: 'foo', type: 'Eth').payload.should == 'foo'
      Packet.new(payload: 'foo', type: 'CAN').payload.should == 'foo'
    end

  end

  describe '#source_mac' do

    it 'returns human-readable source MAC' do
      Packet.new(source_mac: '11:22:33:44:55:66').source_mac.should == '11:22:33:44:55:66'
    end

  end

  describe '#to_bin' do

    it 'returns the binary representation' do
      Packet.new.to_bin.should == "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00"
      Packet.new(
        source_mac:      '11:22:33:44:55:66',
        destination_mac: 'aa:bb:cc:dd:ee:ff',
        payload:         'foo',
        type:            'CAN',
      ).to_bin.should == "\xAA\xBB\xCC\xDD\xEE\xFF\x11\x22\x33\x44\x55\x66\x08\x00\x02foo"
    end

  end

  describe '#to_s' do

    it 'returns a human-readable Packet representation' do
      Packet.new.to_s.should == 'Eth  00 00 00 00 00 00 00 00 00 00 00 00 08 00'
      Packet.new(
        source_mac:      '11:22:33:44:55:66',
        destination_mac: 'aa:bb:cc:dd:ee:ff',
        payload:         'foo',
        type:            'DSS',
      ).to_s.should == 'DSS  aa bb cc dd ee ff 11 22 33 44 55 66 08 00 03 66 6f 6f'
    end

  end

  describe '#type' do

    it 'returns packet type' do
      Packet.new(type: 'Eth').type.should == 'Eth'
      Packet.new(type: 'QoS').type.should == 'QoS'
      Packet.new(type: 'CAN').type.should == 'CAN'
      Packet.new(type: 'DSS').type.should == 'DSS'
      Packet.new(type: 'MGT').type.should == 'MGT'
    end

  end

end end
