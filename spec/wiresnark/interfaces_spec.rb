module Wiresnark module Interfaces

  describe '.[]' do

    it 'returns the requested Interface (creating it only if necessary)' do
      Interface.should_receive(:new).with('lo').and_return lo = mock
      Interfaces['lo'].should == lo

      Interface.should_not_receive :new
      Interfaces['lo'].should == lo
    end

  end

end end
