RSpec.configure do |config|

  config.before do
    Wiresnark::Interface.instance_variable_set :@interfaces, {}
  end

end
