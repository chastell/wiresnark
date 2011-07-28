module Wiresnark module Generator::DSL

  private

  def self.dsl_attr name
    define_method name do |value = nil|
      value.nil? ? params[name] : params[name] = value
    end
  end

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

  public

  dsl_attr :count
  dsl_attr :destination_ip
  dsl_attr :destination_ipv6
  dsl_attr :destination_mac
  dsl_attr :iip_byte
  dsl_attr :payload
  dsl_attr :source_ip
  dsl_attr :source_ipv6
  dsl_attr :source_mac
  dsl_attr :type

end end
