module Wiresnark describe Packet do

  describe '.new' do

    it 'sets sane defaults' do
      Packet.new.destination_ip.should   == '0.0.0.0'
      Packet.new.destination_ipv6.should == '0000:0000:0000:0000:0000:0000:0000:0000'
      Packet.new.destination_mac.should  == '00:00:00:00:00:00'
      Packet.new.iip_byte.should         == 1
      Packet.new.payload.should          == ''
      Packet.new.source_ip.should        == '0.0.0.0'
      Packet.new.source_ipv6.should      == '0000:0000:0000:0000:0000:0000:0000:0000'
      Packet.new.source_mac.should       == '00:00:00:00:00:00'
      Packet.new.type.should             == 'Eth'
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
        payload:        'bar',
      ).to_bin.should == "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x45\x00\x00\x14\x00\x00\x00\x00\x20\x00\xFF\xFF\x01\x02\x03\x04\x05\x06\x07\x08bar"
      Packet.new(
        type:             'IPv6',
        source_ipv6:      '1111:2222:3333:4444:5555:6666:7777:8888',
        destination_ipv6: 'aaaa:bbbb:cccc:dddd:eeee:ffff:1010:1111',
        payload:          'baz',
      ).to_bin.should == "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x86\xDD\x60\x00\x00\x00\x00\x00\x00\xFF\x11\x11\x22\x22\x33\x33\x44\x44\x55\x55\x66\x66\x77\x77\x88\x88\xAA\xAA\xBB\xBB\xCC\xCC\xDD\xDD\xEE\xEE\xFF\xFF\x10\x10\x11\x11baz"
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
