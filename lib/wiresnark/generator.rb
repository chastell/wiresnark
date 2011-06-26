module Wiresnark module Generator

  extend self

  def generate &packet_spec
    gen = Object.new.extend self
    gen.instance_eval &packet_spec
    Array.new(gen.count) { Packet.new type: gen.type }
  end

  def count count = nil
    count ? @count = count : @count ||= 1
  end

  def type type = nil
    type ? @type = type : @type ||= 'Eth'
  end

end end
