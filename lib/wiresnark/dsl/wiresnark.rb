module Wiresnark module DSL module Wiresnark

  def expect_packets_at name, &packet_spec
    expect_packets_at_blocks << { interface: Interface.new(name), packet_spec: packet_spec }
  end

  def expect_packets_at_blocks
    @expect_packets_at_blocks ||= []
  end

  def send_cycle_to name, &packet_spec
    send_cycle_to_blocks << { interface: Interface.new(name), packet_spec: packet_spec }
  end

  def send_cycle_to_blocks
    @send_cycle_to_blocks ||= []
  end

  def send_packets_to name, &packet_spec
    send_packets_to_blocks << { interface: Interface.new(name), packet_spec: packet_spec }
  end

  def send_packets_to_blocks
    @send_packets_to_blocks ||= []
  end

  def verbose
    @verbose = true
  end

  def verbose?
    @verbose
  end

end end end
