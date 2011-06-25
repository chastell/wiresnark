describe Wiresnark do

  describe '.run' do

    it 'executes the passed commands in its own instance' do
      Wiresnark.should_receive(:foo).with :bar
      Wiresnark.run { foo :bar }
    end

  end

end
