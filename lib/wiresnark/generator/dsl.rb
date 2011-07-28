module Wiresnark module Generator::DSL

  [
    :count,
    :destination_ip,
    :destination_ipv6,
    :destination_mac,
    :iip_byte,
    :payload,
    :source_ip,
    :source_ipv6,
    :source_mac,
    :type,
  ].each do |name|
    define_method name do |value = nil|
      value.nil? ? params[name] : params[name] = value
    end
  end

  def params
    @params ||= { count: 1, type: 'Eth' }
  end

end end
