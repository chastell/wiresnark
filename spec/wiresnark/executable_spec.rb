require_relative '../spec_helper'

module Wiresnark describe Executable do
  describe '#run' do
    it 'passes the given file to the runner' do
      runner = MiniTest::Mock.new
      runner.expect :run, nil, ['spec/fixtures/three-to-lo.rb']
      Executable.new(['run', 'spec/fixtures/three-to-lo.rb']).run runner: runner
      runner.verify
    end
  end
end end
