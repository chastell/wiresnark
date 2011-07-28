module Wiresnark module Generator

  extend self

  def generate &packet_spec
    gen = Object.new.extend self::DSL
    gen.instance_eval &packet_spec
    Array.new(gen.params[:count]) { Packet.new gen.params.reject { |key, _| key == :count } }
  end

end end
