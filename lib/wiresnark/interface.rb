module Wiresnark class Interface

  def initialize name
    @name = name
  end

  def expect packets, output = StringIO.new
    capturer = PacketFu::Capture.new iface: @name, start: true
    capturer.save
    captured = capturer.array.map { |bin| Packet.new bin }

    output.puts "captured from #{@name}:"
    captured.each { |packet| output.puts "\t#{packet}" }

    captured == packets
  end

  def inject packets, output = StringIO.new
    PacketFu::Inject.new(@name).inject array: packets.map(&:to_bin)
    output.puts "injected into #{@name}:"
    packets.each { |packet| output.puts "\t#{packet}" }
  end

end end
