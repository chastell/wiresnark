module Wiresnark module Generator

  extend self

  def generate
    [Packet.new(type: 'Eth')]
  end

end end
