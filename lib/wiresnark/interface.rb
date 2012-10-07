module Wiresnark class Interface
  attr_reader :stream

  def initialize name, stream = nil
    @name   = name
    @stream = stream || Stream.for(name)
  end

  def inject packets, output = nil
    packets.each do |packet|
      output.puts "-> #{name}\t#{packet}" if output
      stream << packet.to_bin
    end
  end

  private

  attr_reader :name
end end
