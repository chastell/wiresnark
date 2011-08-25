module Wiresnark module DSL::PacketDSL

  def destination_mac mac = nil
    mac.nil? ? @destination_mac : @destination_mac = mac
  end

  def min_size size = nil
    size.nil? ? @min_size || 60 : @min_size = size
  end

  def payload payload = nil
    payload.nil? ? @payload : @payload = payload
  end

  def source_mac mac = nil
    mac.nil? ? @source_mac : @source_mac = mac
  end

  def type type = nil
    type.nil? ? @type : @type = type
  end

end end
