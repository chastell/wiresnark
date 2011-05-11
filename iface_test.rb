require 'rubygems'
require 'packetfu'
require 'trollop'

opts = Trollop.options do
  opt :count,    'packet count',          :default => 10
  opt :diface,   'destination interface', :default => 'lo'
  opt :siface,   'source interface',      :default => 'lo'
  opt :ip_daddr, 'destination IP',        :default => 'random'
  opt :ip_saddr, 'source IP',             :default => 'random'
  opt :type,     'packet type',           :default => 'TCP'
end

opts[:ip_daddr] = Array.new(4) { rand(256) }.join('.') if opts[:ip_daddr] == 'random'
opts[:ip_saddr] = Array.new(4) { rand(256) }.join('.') if opts[:ip_saddr] == 'random'

puts "generating #{opts[:count]} #{opts[:type]} packets"
packets = Array.new opts[:count] do
  packet = PacketFu::TCPPacket.new
  packet.ip_daddr = opts[:ip_daddr]
  packet.ip_saddr = opts[:ip_saddr]
  packet.payload  = rand.to_s
  packet
end

puts "starting capture on #{opts[:diface]}"
capture = PacketFu::Capture.new :iface => opts[:diface], :start => true

puts "injecting packets into #{opts[:siface]}"
packets.each { |p| p.to_w opts[:siface] }

capture.save

print "captured #{capture.array.size} packets - "
print '*NOT* ' unless (packets.map(&:to_s) - capture.array).empty?
puts 'all generated captured!'
