module Wiresnark module Generator

  extend self

  def generate &packet_spec
    instance_eval &packet_spec
    Array.new(count) { Packet.new(type: 'Eth') }
  end

  def count count = nil
    count ? @count = count : @count ||= 1
  end

end end
