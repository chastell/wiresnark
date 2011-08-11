module Wiresnark describe Executable do

  describe '.new' do

    around do |example|
      $stderr = StringIO.new
      example.run
      $stderr = STDERR
    end

    def stderr
      $stderr.rewind
      $stderr.read
    end

    it 'requires that mentioned files exist' do
      lambda { Executable.new ['foo', '/dev/null', 'bar'] }.should raise_error SystemExit
      stderr.should include 'missing: foo, bar'
    end

    it 'allows for monitoring Interfaces' do
      Pcap.should_receive(:open_live).with('lo', 0xffff, false, 1).and_return ["\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00bar", "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00foo"]

      Executable.new(['--monitor', 'lo']).run output = StringIO.new
      output.rewind
      output.read.should == <<-END
monitoring lo:
\tEth  00:00:00:00:00:00 00:00:00:00:00:00 08 00 62 61 72
\tEth  00:00:00:00:00:00 00:00:00:00:00:00 08 00 66 6f 6f
      END
    end

  end

  describe '#run' do

    it 'executes the passed files' do
      Pcap.should_receive :open_live
      Wiresnark.should_receive :capture_inject_verify
      Executable.new(['spec/fixtures/ten-qos-to-lo.rb']).run
    end

  end

end end
