module Wiresnark class Packet

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
    define_method(name) { params[name] }
  end

  def initialize opts = {}
    params.merge! opts
    @fu_packet = eval "PacketFu::#{type}Packet.new"
    @fu_packet.payload    = payload
    @fu_packet.eth_daddr  = destination_mac
    @fu_packet.eth_saddr  = source_mac
    @fu_packet.ip_id      = ip_id            if @fu_packet.is_ip?
    @fu_packet.ip_daddr   = destination_ip   if @fu_packet.is_ip?
    @fu_packet.ip_saddr   = source_ip        if @fu_packet.is_ip?
    @fu_packet.ipv6_daddr = destination_ipv6 if @fu_packet.is_ipv6?
    @fu_packet.ipv6_saddr = source_ipv6      if @fu_packet.is_ipv6?
  end

  def == other
    params.reject { |key, _| key == :ip_id } == other.params.reject { |key, _| key == :ip_id }
  end

  alias eql? ==

  def hash
    params.reject { |key, _| key == :ip_id }.hash
  end

  def to_bin
    @fu_packet.to_s
  end

  protected

  def params
    @params ||= {
      destination_ip:   '0.0.0.0',
      destination_ipv6: '0000:0000:0000:0000:0000:0000:0000:0000',
      destination_mac:  '00:00:00:00:00:00',
      iip_byte:         1,
      ip_id:            rand(0xffff),
      payload:          '',
      source_ip:        '0.0.0.0',
      source_ipv6:      '0000:0000:0000:0000:0000:0000:0000:0000',
      source_mac:       '00:00:00:00:00:00',
      type:             'Eth',
    }
  end

end end
