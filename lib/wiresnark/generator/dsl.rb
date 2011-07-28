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

  private

  def params
    @params ||= {
      count:            1,
      destination_ip:   '0.0.0.0',
      destination_ipv6: '0000:0000:0000:0000:0000:0000:0000:0000',
      destination_mac:  '00:00:00:00:00:00',
      iip_byte:         1,
      payload:          '',
      source_ip:        '0.0.0.0',
      source_ipv6:      '0000:0000:0000:0000:0000:0000:0000:0000',
      source_mac:       '00:00:00:00:00:00',
      type:             'Eth',
    }
  end

end end
