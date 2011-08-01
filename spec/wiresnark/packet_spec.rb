module Wiresnark describe Packet do

  describe '.new' do

    it 'sets sane defaults' do
      Packet.new.destination_ip.should   == '0.0.0.0'
      Packet.new.destination_ipv6.should == '0000:0000:0000:0000:0000:0000:0000:0000'
      Packet.new.destination_mac.should  == '00:00:00:00:00:00'
      Packet.new.iip_byte.should         == 1
      Packet.new.ip_id.should            be_between 0x0000, 0xffff
      Packet.new.payload.should          == ''
      Packet.new.source_ip.should        == '0.0.0.0'
      Packet.new.source_ipv6.should      == '0000:0000:0000:0000:0000:0000:0000:0000'
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

      Packet.new("\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x86\xDD\x60\x00\x00\x00\x00\x00\x00\xFF\x11\x11\x22\x22\x33\x33\x44\x44\x55\x55\x66\x66\x77\x77\x88\x88\xAA\xAA\xBB\xBB\xCC\xCC\xDD\xDD\xEE\xEE\xFF\xFF\x10\x10\x11\x11baz").should == Packet.new(
        type:             'IPv6',
        source_ipv6:      '1111:2222:3333:4444:5555:6666:7777:8888',
        destination_ipv6: 'aaaa:bbbb:cccc:dddd:eeee:ffff:1010:1111',
        payload:          'baz',
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
      Packet.new(
        type:             'IPv6',
        source_ipv6:      '1111:2222:3333:4444:5555:6666:7777:8888',
        destination_ipv6: 'aaaa:bbbb:cccc:dddd:eeee:ffff:1010:1111',
        payload:          'baz',
      ).to_bin.should == "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x86\xDD\x60\x00\x00\x00\x00\x00\x00\xFF\x11\x11\x22\x22\x33\x33\x44\x44\x55\x55\x66\x66\x77\x77\x88\x88\xAA\xAA\xBB\xBB\xCC\xCC\xDD\xDD\xEE\xEE\xFF\xFF\x10\x10\x11\x11baz"
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
      Packet.new(
        type:             'IPv6',
        source_ipv6:      '1111:2222:3333:4444:5555:6666:7777:8888',
        destination_ipv6: 'aaaa:bbbb:cccc:dddd:eeee:ffff:1010:1111',
        payload:          'baz',
      ).to_s.should == 'IPv6 00 00 00 00 00 00 00 00 00 00 00 00 86 dd 60 00 00 00 00 00 00 ff 11 11 22 22 33 33 44 44 55 55 66 66 77 77 88 88 aa aa bb bb cc cc dd dd ee ee ff ff 10 10 11 11 62 61 7a'
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
