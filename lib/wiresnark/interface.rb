module Wiresnark class Interface

  def self.new name
    @interfaces       ||= {}
    @interfaces[name] ||= super
  end

  def initialize name
    @name = name
  end

  def inject packets, output = StringIO.new
    stream = Pcap.open_live @name, 0xffff, false, 1

    output.puts "injecting into #{@name}:"
    packets.each do |packet|
      stream.inject packet.to_bin
      output.puts "\t#{packet}"
    end
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

    missing = expected - captured
    extra   = captured - expected

    output.puts "captured from #{@name}:"
    captured.each { |packet| output.puts "\t#{packet}" }

    output.puts "missing from #{@name}:" unless missing.empty?
    missing.each { |packet| output.puts "\t#{packet}" }

    output.puts "extra at #{@name}:" unless extra.empty?
    extra.each { |packet| output.puts "\t#{packet}" }

    { result: captured == expected, missing: missing, extra: extra }
  end

end end
