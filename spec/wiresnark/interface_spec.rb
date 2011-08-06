module Wiresnark describe Interface do

  describe '.new' do

    it 'returns the same object for subsequent calls to the same interface' do
      Pcap.should_receive(:open_live).twice
      Interface.new('the same interface').should     equal Interface.new 'the same interface'
      Interface.new('the same interface').should_not equal Interface.new 'some other interface'
    end

  end

  describe '#inject' do

    before do
      Pcap.should_receive(:open_live).with('lo', 0xffff, false, 1).and_return @stream = mock
    end

    it 'injects the passed Packets into the Interface' do
      @stream.should_receive(:inject).with "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00foo"
      @stream.should_receive(:inject).with "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00bar"
      Interface.new('lo').inject [Packet.new(payload: 'foo'), Packet.new(payload: 'bar')]
    end

    it 'puts the information about injected Packets to the passed IO' do
      @stream.should_receive(:inject).twice
      Interface.new('lo').inject [Packet.new(payload: 'foo'), Packet.new(payload: 'bar')], output = StringIO.new
      output.rewind
      output.read.should == <<-END
injecting into lo:
\tEth  00 00 00 00 00 00 00 00 00 00 00 00 08 00 66 6f 6f
\tEth  00 00 00 00 00 00 00 00 00 00 00 00 08 00 62 61 72
      END
    end

  end

  describe '#monitor' do

    it 'outputs captured Packets to the given output' do
      Pcap.should_receive(:open_live).with('lo', 0xffff, false, 1).and_return ["\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00bar", "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00foo"]
      Interface.new('lo').monitor output = StringIO.new
      output.rewind
      output.read.should == <<-END
monitoring lo:
\tEth  00 00 00 00 00 00 00 00 00 00 00 00 08 00 62 61 72
\tEth  00 00 00 00 00 00 00 00 00 00 00 00 08 00 66 6f 6f
      END
    end

  end

  describe '#start_capture' do

    it 'starts packet capture by the given interface' do
      Pcap.should_receive(:open_live).with 'lo', 0xffff, false, 1
      Interface.new('lo').start_capture
    end

  end

  describe '#verify_capture' do

    before do
      Pcap.should_receive(:open_live).with('lo', 0xffff, false, 1).and_return @stream = mock
    end

    it 'returns true/none-missing/none-extra if captured packets equal passed ones' do
      @stream.should_receive(:next).and_return "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00foo", "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00bar", nil
      Interface.new('lo').verify_capture([Packet.new(payload: 'foo'), Packet.new(payload: 'bar')]).should == {
        result:  true,
        missing: [],
        extra:   [],
      }
    end

    it 'returns false/missing/extra if captured packets differ from the passed ones' do
      @stream.should_receive(:next).and_return "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00foo", "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00baz", nil
      Interface.new('lo').verify_capture([Packet.new(payload: 'foo'), Packet.new(payload: 'bar')]).should == {
        result:  false,
        missing: [Packet.new(payload: 'bar')],
        extra:   [Packet.new(payload: 'baz')],
      }
    end

    it 'puts the information about captured/missing/extra Packets to the passed IO' do
      @stream.should_receive(:next).and_return "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00foo", "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00baz", nil
      Interface.new('lo').verify_capture [Packet.new(payload: 'foo'), Packet.new(payload: 'bar')], output = StringIO.new
      output.rewind
      output.read.should == <<-END
captured from lo:
\tEth  00 00 00 00 00 00 00 00 00 00 00 00 08 00 66 6f 6f
\tEth  00 00 00 00 00 00 00 00 00 00 00 00 08 00 62 61 7a
missing from lo:
\tEth  00 00 00 00 00 00 00 00 00 00 00 00 08 00 62 61 72
extra at lo:
\tEth  00 00 00 00 00 00 00 00 00 00 00 00 08 00 62 61 7a
      END
    end

  end

end end
