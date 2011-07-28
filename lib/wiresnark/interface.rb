module Wiresnark class Interface

  def initialize name
    @name = name
  end

  def inject packets
    PacketFu::Inject.new(@name).inject array: packets.map(&:to_bin)
  end

end end
