module Wiresnark module DSL

  def expect_packets_at interface, &packet_spec
    expectations << { interface: Interface.new(interface), packet_spec: packet_spec }
  end

  def expectations
    @expectations ||= []
  end

  def generations
    @generations ||= []
  end

  def send_packets_to interface, &packet_spec
    generations << { interface: Interface.new(interface), packet_spec: packet_spec }
  end

end end
