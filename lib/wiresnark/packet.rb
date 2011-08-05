module Wiresnark class Packet

  [
    :destination_ip,
    :destination_mac,
    :iip_byte,
    :ip_id,
    :payload,
    :source_ip,
    :source_mac,
    :type,
  ].each do |name|
    define_method(name) { params[name] }
  end

  def initialize arg = {}
    case arg

    when Hash
      params.merge! arg
      @fu_packet         = type == 'IIP' ? eval('PacketFu::EthPacket.new') : eval("PacketFu::#{type}Packet.new")
      @fu_packet.payload = type == 'IIP' ? iip_byte.chr + payload          : payload

      @fu_packet.eth_daddr  = destination_mac
      @fu_packet.eth_saddr  = source_mac
      @fu_packet.ip_id      = ip_id            if @fu_packet.is_ip?
      @fu_packet.ip_daddr   = destination_ip   if @fu_packet.is_ip?
      @fu_packet.ip_saddr   = source_ip        if @fu_packet.is_ip?

    when String
      @fu_packet = PacketFu::Packet.parse arg
      params.merge!({
        type:            @fu_packet.protocol.last,
        payload:         @fu_packet.payload,
        destination_mac: @fu_packet.eth_daddr,
        source_mac:      @fu_packet.eth_saddr,
      })
      params.merge!({
        ip_id:          @fu_packet.ip_id,
        destination_ip: @fu_packet.ip_daddr,
        source_ip:      @fu_packet.ip_saddr,
      }) if @fu_packet.is_ip?
    end
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

  def to_s
    "#{type.ljust 4} #{to_bin.split(//).map { |c| c.ord.to_s(16).rjust 2, '0' }.join ' '}"
  end

  protected

  def params
    @params ||= {
      destination_ip:   '0.0.0.0',
      destination_mac:  '00:00:00:00:00:00',
      iip_byte:         1,
      ip_id:            rand(0xffff),
      payload:          '',
      source_ip:        '0.0.0.0',
      source_mac:       '00:00:00:00:00:00',
      type:             'Eth',
    }
  end

end end
