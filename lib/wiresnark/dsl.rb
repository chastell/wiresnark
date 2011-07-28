module Wiresnark module DSL

  extend self

  def expect_packets_at interface, &packet_spec
    Interfaces[interface].expect Generator.generate &packet_spec
  end

  def send_packets_to interface, &packet_spec
    Interfaces[interface].inject Generator.generate &packet_spec
  end

end end
