module Wiresnark module Generator

  def self.generate &packet_spec
    gen = Object.new.extend DSL::Packet
    gen.instance_eval &packet_spec
    Array.new(gen.count) { Packet.new gen.params }
  end

end end
