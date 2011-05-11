require 'rubygems'
require 'packetfu'
require 'trollop'

opts = Trollop.options do
  opt :count,   'packet count',          :default => 10
  opt :d_iface, 'destination interface', :default => 'lo'
  opt :s_iface, 'source interface',      :default => 'lo'
  opt :type,    'packet type',           :default => 'TCP'
end

puts "generating #{opts[:count]} #{opts[:type]} packets"
packets = (1..opts[:count]).map do
  packet = PacketFu::TCPPacket.new
  packet.ip_saddr = [rand(256), rand(256), rand(256), rand(256)].join '.'
  packet.ip_daddr = [rand(256), rand(256), rand(256), rand(256)].join '.'
  packet.payload  = rand.to_s
  packet.to_s
end

puts "starting capture on #{opts[:d_iface]}"
capture = PacketFu::Capture.new :iface => opts[:d_iface], :start => true

puts "injecting packets into #{opts[:s_iface]}"
inject = PacketFu::Inject.new :iface => opts[:s_iface]
inject.array_to_wire :array => packets

capture.save

print "captured #{capture.array.size} packets - "
print '*NOT* ' unless (packets - capture.array).empty?
puts 'all generated captured!'
