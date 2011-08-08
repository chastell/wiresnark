module Wiresnark class Interface

  def self.new name
    @interfaces       ||= {}
    @interfaces[name] ||= super
  end

  def initialize name
    @name   = name
    @stream = Pcap.open_live name, 0xffff, false, 1
  end

  def inject packets, output = nil
    output.puts "injecting into #{@name}:" if output
    packets.each do |packet|
      @stream.inject packet.to_bin
      output.puts "\t#{packet}" if output
    end
  end

  def monitor output
    output.puts "monitoring #{@name}:"
    @stream.each { |packet| output.puts "\t#{Packet.new packet}" }
  end

  def verify_capture expected, output = nil
    captured = []
    while bin = @stream.next
      captured << Packet.new(bin)
    end

    missing = expected - captured
    extra   = captured - expected

    if output
      output.puts "captured from #{@name}:"
      captured.each { |packet| output.puts "\t#{packet}" }

      output.puts "missing from #{@name}:" unless missing.empty?
      missing.each { |packet| output.puts "\t#{packet}" }

      output.puts "extra at #{@name}:" unless extra.empty?
      extra.each { |packet| output.puts "\t#{packet}" }
    end

    { result: captured == expected, missing: missing, extra: extra }
  end

end end
