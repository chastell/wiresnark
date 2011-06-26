module Wiresnark module DSL

  extend self

  def send_packets_to interface, &packet_spec
    packets = Generator.generate &packet_spec
    Interfaces[interface].inject packets
  end

end end
