require_relative '../spec_helper'

module Wiresnark describe Runner do
  describe '#run' do
    it 'evaluates the passed file and sends packets as per spec' do
      skip if Process.uid.zero?

      env = MiniTest::Mock.new
      env.expect :instance_eval,    nil, [File.read('spec/fixtures/three-to-lo.rb')]
      env.expect :generator_blocks, []
      env.expect :monitor_blocks,   []

      Runner.new.run 'spec/fixtures/three-to-lo.rb', env

      env.verify
    end

    it 'outputs the traffic info if so instructed' do
      skip if Process.uid.zero?

      -> { Runner.new.run 'spec/fixtures/three-to-lo.rb' }.must_output <<-end.gsub(/^ */, '')
        -> lo\tNIL\t60\t[00:00:00:00:00:00] [00:00:00:00:00:00] [08.00] [00] [0000000000]
        -> lo\tNIL\t60\t[00:00:00:00:00:00] [00:00:00:00:00:00] [08.00] [00] [0000000001]
        -> lo\tNIL\t60\t[00:00:00:00:00:00] [00:00:00:00:00:00] [08.00] [00] [0000000002]
        lo ->\tNIL\t60\t[00:00:00:00:00:00] [00:00:00:00:00:00] [08.00] [00] [0000000000]
        lo ->\tNIL\t60\t[00:00:00:00:00:00] [00:00:00:00:00:00] [08.00] [00] [0000000001]
        lo ->\tNIL\t60\t[00:00:00:00:00:00] [00:00:00:00:00:00] [08.00] [00] [0000000002]
        \t3 NIL\t180 bytes\t60 bytes/packet

      end
    end

    it 'cycles through the packet types if so instructed' do
      skip if Process.uid.zero?

      out = capture_io { Runner.new.run 'spec/fixtures/cycle-to-lo.rb' }.first

      out.must_match(/#{'QOS.*CAN.*DSS.*MGT.*' * 4}/m)
      out.count('QOS').must_be :>, out.count('MGT')
    end

    it 'includes packet counts and size sums on packet type changes' do
      skip if Process.uid.zero?

      capture_io { Runner.new.run 'spec/fixtures/cycle-to-lo.rb' }.first.must_include "\t1 MGT\t60 bytes"
    end

    it 'includes only packet counts and size sums in non-verbose mode' do
      skip if Process.uid.zero?

      out = capture_io { Runner.new.run 'spec/fixtures/quiet-lo.rb' }.first

      out.wont_include "-> lo\tNIL\t60"
      out.must_include "\t3 NIL\t180 bytes"
    end

    it 'includes per-type running tally in running_tally mode' do
      skip if Process.uid.zero?

      out = capture_io { Runner.new.run 'spec/fixtures/running-tally.rb' }.first

      out.must_match 'NIL:     6 p,   360 b,    60 b/p    DSS:     4 p,   240 b,    60 b/p    CAN:     3 p,   180 b,    60 b/p    QOS:     2 p,   120 b,    60 b/p    MGT:     5 p,   300 b,    60 b/p'
    end
  end
end end
