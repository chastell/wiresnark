module Wiresnark module Interfaces

  describe '.[]' do

    it 'returns the requested Interface (creating it only if necessary)' do
      iface_name = 'Interfaces.[] spec interface'

      Interface.should_receive(:new).with(iface_name).and_return iface = mock
      Interfaces[iface_name].should == iface

      Interface.should_not_receive :new
      Interfaces[iface_name].should == iface
    end

  end

end end
