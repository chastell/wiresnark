module Wiresnark module Generator

  extend self

  def generate &packet_spec
    gen = Object.new.extend Packet::DSL
    gen.instance_eval &packet_spec
    Array.new(gen.count) { Packet.new gen.params }
  end

end end
