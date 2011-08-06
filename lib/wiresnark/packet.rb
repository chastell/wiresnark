module Wiresnark class Packet

  IIPBytes = {
    'QoS' => "\x01",
    'CAN' => "\x02",
    'DSS' => "\x03",
    'MGT' => "\x04",
  }

  IIPTypes = IIPBytes.invert

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
      @fu_packet           = PacketFu::EthPacket.new
      @fu_packet.payload   = type == 'Eth' ? payload : IIPBytes[type] + payload
      @fu_packet.eth_daddr = destination_mac
      @fu_packet.eth_saddr = source_mac

    when String
      @fu_packet = PacketFu::Packet.parse arg
      params.merge!({
        payload:         @fu_packet.payload,
        destination_mac: @fu_packet.eth_daddr,
        source_mac:      @fu_packet.eth_saddr,
      })
      params.merge!({
        payload: @fu_packet.payload[1..-1],
        type:    IIPTypes[@fu_packet.payload[0]],
      }) if IIPTypes[@fu_packet.payload[0]]
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
