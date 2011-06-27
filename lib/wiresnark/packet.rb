module Wiresnark class Packet

  attr_reader :type

  def initialize opts
    @type = opts[:type]
  end

  def == other
    type == other.type
  end

  alias eql? ==

  def hash
    @type.hash
  end

end end
