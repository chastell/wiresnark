module Wiresnark module Packet::DSL

  [
    :destination_ip,
    :destination_ipv6,
    :destination_mac,
    :iip_byte,
    :ip_id,
    :payload,
    :source_ip,
    :source_ipv6,
    :source_mac,
    :type,
  ].each do |name|
    define_method(name) { |value| params[name] = value }
  end

  def count count = nil
    count.nil? ? @count ||= 1 : @count = count
  end

  def params
    @params ||= {}
  end

end end
