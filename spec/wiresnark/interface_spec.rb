module Wiresnark describe Interface do

  describe '.new' do

    it 'returns the same object for subsequent calls to the same interface' do
      Interface.new('the same interface').should     equal Interface.new 'the same interface'
      Interface.new('the same interface').should_not equal Interface.new 'some other interface'
    end

  end

  describe '#inject' do

    before do
      PacketFu::Inject.should_receive(:new).with('lo').and_return @injector = mock
    end

    it 'injects the passed Packets into the Interface' do
      @injector.should_receive(:inject).with array: ["\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00foo", "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00bar"]
      Interface.new('lo').inject [Packet.new(payload: 'foo'), Packet.new(payload: 'bar')]
    end

    it 'puts the information about injected Packets to the passed IO' do
      @injector.should_receive :inject
      Interface.new('lo').inject [Packet.new(payload: 'foo'), Packet.new(payload: 'bar')], output = StringIO.new
      output.rewind
      output.read.should == <<-END
injected into lo:
\tEth  00 00 00 00 00 00 00 00 00 00 00 00 08 00 66 6f 6f
\tEth  00 00 00 00 00 00 00 00 00 00 00 00 08 00 62 61 72
      END
    end

  end

  describe '#start_capture' do

    it 'starts packet capture by the given interface' do
      PacketFu::Capture.should_receive(:new).with iface: 'lo', start: true
      Interface.new('lo').start_capture
    end

  end

  describe '#verify_capture' do

    before do
      PacketFu::Capture.should_receive(:new).with(iface: 'lo', start: true).and_return @capturer = mock
      @capturer.should_receive :save
      Interface.new('lo').start_capture
    end

    it 'returns true if captured packets equal the passed ones' do
      @capturer.should_receive(:array).and_return ["\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00foo", "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00bar"]
      Interface.new('lo').verify_capture([Packet.new(payload: 'foo'), Packet.new(payload: 'bar')]).should == true
    end

    it 'returns false if captured packets differ from the passed ones' do
      @capturer.should_receive(:array).and_return ["\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00foo", "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00baz"]
      Interface.new('lo').verify_capture([Packet.new(payload: 'foo'), Packet.new(payload: 'bar')]).should == false
    end

    it 'puts the information about captured Packets to the passed IO' do
      @capturer.should_receive(:array).and_return ["\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00foo", "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00bar"]
      Interface.new('lo').verify_capture [Packet.new(payload: 'foo'), Packet.new(payload: 'bar')], output = StringIO.new
      output.rewind
      output.read.should == <<-END
captured from lo:
\tEth  00 00 00 00 00 00 00 00 00 00 00 00 08 00 66 6f 6f
\tEth  00 00 00 00 00 00 00 00 00 00 00 00 08 00 62 61 72
      END
    end

  end

end end
