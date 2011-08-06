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
    end

    it 'properly creates IIP Packets' do
      Packet.new(
        source_mac:      '11:22:33:44:55:66',
        destination_mac: 'aa:bb:cc:dd:ee:ff',
        payload:         'foo',
      ).to_bin.should == "\xAA\xBB\xCC\xDD\xEE\xFF\x11\x22\x33\x44\x55\x66\x08\x00foo"
      Packet.new(
        source_mac:      '11:22:33:44:55:66',
        destination_mac: 'aa:bb:cc:dd:ee:ff',
        payload:         'bar',
        type:            'IIP 1',
      ).to_bin.should == "\xAA\xBB\xCC\xDD\xEE\xFF\x11\x22\x33\x44\x55\x66\x08\x00\x01bar"
      Packet.new(
        source_mac:      '11:22:33:44:55:66',
        destination_mac: 'aa:bb:cc:dd:ee:ff',
        payload:         'baz',
        type:            'IIP 2',
      ).to_bin.should == "\xAA\xBB\xCC\xDD\xEE\xFF\x11\x22\x33\x44\x55\x66\x08\x00\x02baz"
    end

  end

  describe '#==' do

    it 'tests equality' do
      Packet.new.should                  == Packet.new(type: 'Eth', payload: '')
      Packet.new(type: 'Eth').should_not == Packet.new(type: 'IIP 1')
      Packet.new(type: 'Eth').should_not == Packet.new(type: 'Eth', payload: 'foo')
    end

  end

  describe '#eql?' do

    it 'matches #== for equality' do
      Packet.new.should                  be_eql Packet.new(type: 'Eth', payload: '')
      Packet.new(type: 'Eth').should_not be_eql Packet.new(type: 'IIP 1')
      Packet.new(type: 'Eth').should_not be_eql Packet.new(type: 'Eth', payload: 'foo')
    end

  end

  describe '#hash' do

    it 'returns the same hash for eql? Packets' do
      Packet.new.hash.should == Packet.new(type: 'Eth', payload: '').hash
    end

  end

  describe '#to_bin' do

    it 'returns the binary representation' do
      Packet.new.to_bin.should == "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00"
      Packet.new(
        source_mac:      '11:22:33:44:55:66',
        destination_mac: 'aa:bb:cc:dd:ee:ff',
        payload:         'foo',
        type:            'IIP 2',
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
      ).to_s.should == 'Eth  aa bb cc dd ee ff 11 22 33 44 55 66 08 00 66 6f 6f'
    end

  end

  describe '#{params}' do

    it 'returns the various param values' do
      Packet.new.type.should                == 'Eth'
      Packet.new(type: 'IIP 1').type.should == 'IIP 1'
      Packet.new.payload.should                 == ''
      Packet.new(payload: 'foo').payload.should == 'foo'
    end

  end

end end
