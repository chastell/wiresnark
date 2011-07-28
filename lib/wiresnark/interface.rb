module Wiresnark class Interface

  def initialize name
    @name = name
  end

  def inject packets, output = StringIO.new
    PacketFu::Inject.new(@name).inject array: packets.map(&:to_bin)
    output.puts "injected into #{@name}:"
    packets.each { |packet| output.puts "\t#{packet}" }
  end

end end
