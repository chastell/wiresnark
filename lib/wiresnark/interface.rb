module Wiresnark class Interface

  def initialize name
    @name = name
  end

  def expect packets
    capturer = PacketFu::Capture.new iface: @name, start: true
    capturer.save
    capturer.array.map { |bin| Packet.new bin } == packets
  end

  def inject packets, output = StringIO.new
    PacketFu::Inject.new(@name).inject array: packets.map(&:to_bin)
    output.puts "injected into #{@name}:"
    packets.each { |packet| output.puts "\t#{packet}" }
  end

end end
