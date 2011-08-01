module Wiresnark class Interface

  def self.new name
    @interfaces       ||= {}
    @interfaces[name] ||= super
  end

  def initialize name
    @name = name
  end

  def inject packets, output = StringIO.new
    PacketFu::Inject.new(iface: @name).inject array: packets.map(&:to_bin)
    output.puts "injected into #{@name}:"
    packets.each { |packet| output.puts "\t#{packet}" }
  end

  def monitor output
    output.puts "monitoring #{@name}:"
    Pcap.open_live(@name, 0xffff, false, 1).each { |packet| output.puts "\t#{Packet.new packet}" }
  end

  def start_capture
    @capture = PacketFu::Capture.new iface: @name, start: true
  end

  def verify_capture expected, output = StringIO.new
    @capture.save
    captured = @capture.array.map { |bin| Packet.new bin }

    output.puts "captured from #{@name}:"
    captured.each { |packet| output.puts "\t#{packet}" }

    {
      result:  captured == expected,
      missing: expected - captured,
      extra:   captured - expected,
    }
  end

end end
