module Wiresnark module Generator

  def self.generate &packet_spec
    gen = Object.new.extend DSL::Packet
    gen.instance_eval &packet_spec
    Array.new(gen.count) { Packet.new gen.params }
  end

  def self.generate_for_cycle &packet_spec
    gen = Object.new.extend DSL::Packet
    gen.instance_eval &packet_spec
    Hash[
      gen.phase_types.map do |type|
        [type, Array.new(gen.phase_usec) { Packet.new gen.params.merge({ type: type }) }]
      end
    ]
  end

end end
