# encoding: UTF-8

describe Wiresnark do

  describe '.run' do

    it 'executes the passed commands in DSL’s instance' do
      Wiresnark::DSL.should_receive(:foo).with :bar
      Wiresnark.run { foo :bar }
    end

  end

end
