module Wiresnark describe Packet do

  describe '.new' do

    it 'sets sane defaults' do
      Packet.new.destination_ip.should   == '0.0.0.0'
      Packet.new.destination_mac.should  == '00:00:00:00:00:00'
      Packet.new.iip_byte.should         == 1
      Packet.new.ip_id.should            be_between 0x0000, 0xffff
      Packet.new.payload.should          == ''
      Packet.new.source_ip.should        == '0.0.0.0'
      Packet.new.source_mac.should       == '00:00:00:00:00:00'
      Packet.new.type.should             == 'Eth'
    end

    it 'randomises #ip_id' do
      Packet.new.ip_id.should_not == Packet.new.ip_id
    end

    it 'creates Packet by parsing the passed binary' do
      Packet.new("\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00").should == Packet.new

      Packet.new("\xAA\xBB\xCC\xDD\xEE\xFF\x11\x22\x33\x44\x55\x66\x08\x00foo").should == Packet.new(
        source_mac:      '11:22:33:44:55:66',
        destination_mac: 'aa:bb:cc:dd:ee:ff',
        payload:         'foo',
      )

      Packet.new("\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x45\x00\x00\x14\xba\xbe\x00\x00\x20\x00\xFF\xFF\x01\x02\x03\x04\x05\x06\x07\x08bar").should == Packet.new(
        type:           'IP',
        source_ip:      '1.2.3.4',
        destination_ip: '5.6.7.8',
        ip_id:          0xbabe,
        payload:        'bar',
      )
    end

    it 'properly creates IIP Packets' do
      Packet.new(
        source_mac:      '11:22:33:44:55:66',
        destination_mac: 'aa:bb:cc:dd:ee:ff',
        payload:         'foo',
      ).to_bin.should == "\xAA\xBB\xCC\xDD\xEE\xFF\x11\x22\x33\x44\x55\x66\x08\x00foo"
      Packet.new(
        type:            'IIP',
        source_mac:      '11:22:33:44:55:66',
        destination_mac: 'aa:bb:cc:dd:ee:ff',
        payload:         'foo',
      ).to_bin.should == "\xAA\xBB\xCC\xDD\xEE\xFF\x11\x22\x33\x44\x55\x66\x08\x00\x01foo"
      Packet.new(
        type:            'IIP',
        iip_byte:        2,
        source_mac:      '11:22:33:44:55:66',
        destination_mac: 'aa:bb:cc:dd:ee:ff',
        payload:         'foo',
      ).to_bin.should == "\xAA\xBB\xCC\xDD\xEE\xFF\x11\x22\x33\x44\x55\x66\x08\x00\x02foo"
    end

  end

  describe '#==' do

    it 'tests equality' do
      Packet.new.should                  == Packet.new(type: 'Eth', payload: '')
      Packet.new(type: 'Eth').should_not == Packet.new(type: 'TCP')
      Packet.new(type: 'Eth').should_not == Packet.new(type: 'Eth', payload: 'foo')
    end

  end

  describe '#eql?' do

    it 'matches #== for equality' do
      Packet.new.should                  be_eql Packet.new(type: 'Eth', payload: '')
      Packet.new(type: 'Eth').should_not be_eql Packet.new(type: 'TCP')
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
      ).to_bin.should == "\xAA\xBB\xCC\xDD\xEE\xFF\x11\x22\x33\x44\x55\x66\x08\x00foo"
      Packet.new(
        type:           'IP',
        source_ip:      '1.2.3.4',
        destination_ip: '5.6.7.8',
        ip_id:          0xbabe,
        payload:        'bar',
      ).to_bin.should == "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x45\x00\x00\x14\xba\xbe\x00\x00\x20\x00\xFF\xFF\x01\x02\x03\x04\x05\x06\x07\x08bar"
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
      Packet.new(
        type:           'IP',
        source_ip:      '1.2.3.4',
        destination_ip: '5.6.7.8',
        ip_id:          0xbabe,
        payload:        'bar',
      ).to_s.should == 'IP   00 00 00 00 00 00 00 00 00 00 00 00 08 00 45 00 00 14 ba be 00 00 20 00 ff ff 01 02 03 04 05 06 07 08 62 61 72'
    end

  end

  describe '#{params}' do

    it 'returns the various param values' do
      Packet.new.type.should              == 'Eth'
      Packet.new(type: 'TCP').type.should == 'TCP'
      Packet.new.payload.should                 == ''
      Packet.new(payload: 'foo').payload.should == 'foo'
    end

  end

end end
