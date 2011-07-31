module Wiresnark describe Interface do

  describe '.new' do

    it 'returns the same object for subsequent calls to the same interface' do
      name = 'Interface.new spec interface'
      Interface.new(name).should     equal Interface.new name
      Interface.new(name).should_not equal Interface.new 'some other Interface.new spec interface'
    end

  end

  describe '#expect' do

    before do
      @iface_name = 'Interface#expect spec interface'
      PacketFu::Capture.should_receive(:new).with(iface: @iface_name, start: true).and_return @capturer = mock
      @capturer.should_receive :save
    end

    it 'captures packets and returns true if they equal the passed ones' do
      @capturer.should_receive(:array).and_return ["\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00foo", "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00bar"]
      Interface.new(@iface_name).expect([Packet.new(payload: 'foo'), Packet.new(payload: 'bar')]).should == true
    end

    it 'captures packets and returns false if they differ from the passed ones' do
      @capturer.should_receive(:array).and_return ["\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00foo", "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00baz"]
      Interface.new(@iface_name).expect([Packet.new(payload: 'foo'), Packet.new(payload: 'bar')]).should == false
    end

    it 'puts the information about captured Packets to the passed IO' do
      @capturer.should_receive(:array).and_return ["\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00foo", "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00bar"]
      Interface.new(@iface_name).expect [Packet.new(payload: 'foo'), Packet.new(payload: 'bar')], output = StringIO.new
      output.rewind
      output.read.should == <<-END
captured from #{@iface_name}:
\tEth  00 00 00 00 00 00 00 00 00 00 00 00 08 00 66 6f 6f
\tEth  00 00 00 00 00 00 00 00 00 00 00 00 08 00 62 61 72
      END
    end

  end

  describe '#inject' do

    before do
      @iface_name = 'Interface#inject spec interface'
      PacketFu::Inject.should_receive(:new).with(@iface_name).and_return @injector = mock
    end

    it 'injects the passed Packets into the Interface' do
      @injector.should_receive(:inject).with array: ["\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00foo", "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00bar"]
      Interface.new(@iface_name).inject [Packet.new(payload: 'foo'), Packet.new(payload: 'bar')]
    end

    it 'puts the information about injected Packets to the passed IO' do
      @injector.should_receive :inject
      Interface.new(@iface_name).inject [Packet.new(payload: 'foo'), Packet.new(payload: 'bar')], output = StringIO.new
      output.rewind
      output.read.should == <<-END
injected into #{@iface_name}:
\tEth  00 00 00 00 00 00 00 00 00 00 00 00 08 00 66 6f 6f
\tEth  00 00 00 00 00 00 00 00 00 00 00 00 08 00 62 61 72
      END
    end

  end

end end
