module Wiresnark class Packet

  IIPBytes = {
    'Eth' => '',
    'QoS' => "\x01",
    'CAN' => "\x02",
    'DSS' => "\x03",
    'MGT' => "\x04",
  }

  IIPTypes = IIPBytes.invert

  def initialize arg = {}
    case arg
    when Hash
      arg[:destination_mac] ||= '00:00:00:00:00:00'
      arg[:payload]         ||= ''
      arg[:source_mac]      ||= '00:00:00:00:00:00'
      arg[:type]            ||= 'Eth'
      @bin =
        arg[:destination_mac].split(':').pack('H2H2H2H2H2H2') +
        arg[:source_mac].split(':').pack('H2H2H2H2H2H2') +
        "\x08\x00" +
        IIPBytes[arg[:type]] +
        arg[:payload]
    when String
      @bin = arg
    end
  end

  def == other
    to_bin == other.to_bin
  end

  def destination_mac
    @bin[0..5].unpack('H2H2H2H2H2H2').join ':'
  end

  def destination_mac= mac
    @bin[0..5] = mac.split(':').pack 'H2H2H2H2H2H2'
  end

  alias eql? ==

  def hash
    @bin.hash
  end

  def payload
    type == 'Eth' ? @bin[14..-1] : @bin[15..-1]
  end

  def payload= payload
    type == 'Eth' ? @bin[14..-1] = payload : @bin[15..-1] = payload
  end

  def source_mac
    @bin[6..11].unpack('H2H2H2H2H2H2').join ':'
  end

  def source_mac= mac
    @bin[6..11] = mac.split(':').pack 'H2H2H2H2H2H2'
  end

  def to_bin
    @bin
  end

  def to_s
    "#{type.ljust 4} #{to_bin.split(//).map { |c| c.ord.to_s(16).rjust 2, '0' }.join ' '}"
  end

  def type
    IIPTypes[@bin[14]] or 'Eth'
  end

  def type= type
    self.type == 'Eth' ? @bin.insert(14, IIPBytes[type]) : @bin[14] = IIPBytes[type]
  end

end end
