module Wiresnark module DSL

  def expect_packets_at name, &packet_spec
    expectations << { interface: Interface.new(name), packet_spec: packet_spec }
  end

  def expectations
    @expectations ||= []
  end

  def generations
    @generations ||= []
  end

  def send_packets_to name, &packet_spec
    generations << { interface: Interface.new(name), packet_spec: packet_spec }
  end

end end
