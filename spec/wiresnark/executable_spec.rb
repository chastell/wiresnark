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

  end

end end
