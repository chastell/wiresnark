module Wiresnark class Packet

  TypeBytes = {
    'Eth' => '',
    'QoS' => "\x01",
    'CAN' => "\x02",
    'DSS' => "\x03",
    'MGT' => "\x04",
  }

  def initialize arg = {}
    case arg
    when Hash
      @bin = "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00"
      self.destination_mac = arg[:destination_mac] if arg[:destination_mac]
      self.payload         = arg[:payload]         if arg[:payload]
      self.source_mac      = arg[:source_mac]      if arg[:source_mac]
      self.type            = arg[:type]            if arg[:type]
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
    "#{type}  #{@bin.unpack('H2' * @bin.size).join ' '}"
  end

  def type
    TypeBytes.invert[@bin[14]] or 'Eth'
  end

  def type= type
    self.type == 'Eth' ? @bin.insert(14, TypeBytes[type]) : @bin[14] = TypeBytes[type]
  end

end end
