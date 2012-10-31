module Wiresnark class Packet
  def initialize arg = {}
    case arg
    when Hash
      @bin = "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00"

      self.destination_mac = arg[:destination_mac] if arg[:destination_mac]
      self.source_mac      = arg[:source_mac]      if arg[:source_mac]
      self.type            = arg[:type]            if arg[:type]
      self.payload         = arg[:payload]         if arg[:payload]

      pad_to arg[:random_size] ? Random.new.rand(arg[:random_size]) : arg[:min_size] || 60
    when String
      @bin = arg
    end
  end

  def == other
    to_bin == other.to_bin
  end

  def destination_mac
    bin[0..5].unpack('H2H2H2H2H2H2').join ':'
  end

  def destination_mac= mac
    bin[0..5] = mac.split(':').pack 'H2H2H2H2H2H2'
  end

  def payload
    bin[15..-1]
  end

  def payload= payload
    orig_size = size
    bin[15..-1] = payload
    pad_to orig_size
  end

  def size
    bin.size
  end

  def source_mac
    bin[6..11].unpack('H2H2H2H2H2H2').join ':'
  end

  def source_mac= mac
    bin[6..11] = mac.split(':').pack 'H2H2H2H2H2H2'
  end

  def to_bin
    bin
  end

  def to_s
    ethertype = bin[12..13].unpack('H*').first.insert 2, '.'
    type_byte = bin[14].unpack('H*').first
    payload   = bin[15..19].unpack('H*').first
    "#{type}\t#{size}\t[#{destination_mac}] [#{source_mac}] [#{ethertype}] [#{type_byte}] [#{payload}]"
  end

  def type
    TypeBytes.invert[bin[14].ord] or 'NIL'
  end

  def type= type
    bin[14] = TypeBytes[type].chr
  end

  attr_reader :bin
  private     :bin

  private

  def pad_to min_size
    bin << "\x00" * (min_size - size) if size < min_size
  end
end end
