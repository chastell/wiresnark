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
      @fu_packet           = PacketFu::EthPacket.new
      @fu_packet.payload   = type.start_with?('IIP ') ? type[4].to_i.chr + payload : payload
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
        type:    "IIP #{@fu_packet.payload[0].ord}",
      }) if ("\x01".."\x04").include? @fu_packet.payload[0]
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
