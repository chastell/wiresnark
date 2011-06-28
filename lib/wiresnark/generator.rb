module Wiresnark module Generator

  extend self

  def generate &packet_spec
    gen = Object.new.extend self::DSL
    gen.instance_eval &packet_spec
    Array.new(gen.count) { Packet.new type: gen.type }
  end

end end
