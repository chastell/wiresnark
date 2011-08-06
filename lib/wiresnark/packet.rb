module Wiresnark class Packet

  [
    :destination_mac,
    :payload,
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
      @fu_packet.payload = type == 'IIP' ? "\x01" + payload                : payload

      @fu_packet.eth_daddr  = destination_mac
      @fu_packet.eth_saddr  = source_mac

    when String
      @fu_packet = PacketFu::Packet.parse arg
      params.merge!({
        type:            @fu_packet.protocol.last,
        payload:         @fu_packet.payload,
        destination_mac: @fu_packet.eth_daddr,
        source_mac:      @fu_packet.eth_saddr,
      })
    end
  end

  def == other
    params == other.params
  end

  alias eql? ==

  def hash
    params.hash
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
      destination_mac:  '00:00:00:00:00:00',
      payload:          '',
      source_mac:       '00:00:00:00:00:00',
      type:             'Eth',
    }
  end

end end
