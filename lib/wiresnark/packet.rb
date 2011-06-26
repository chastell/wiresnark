module Wiresnark class Packet

  attr_reader :type

  def initialize opts
    @type = opts[:type]
  end

  def == other
    type == other.type
  end

end end
