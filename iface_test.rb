require 'rubygems'
require 'packetfu'
require 'trollop'

opts = Trollop.options do
  opt :count,    'packet count',          :default => 10
  opt :diface,   'destination interface', :default => 'lo'
  opt :siface,   'source interface',      :default => 'lo'
  opt :eth_dst,  'destination MAC',       :default => 'random'
  opt :eth_src,  'source MAC',            :default => 'random'
  opt :ip_daddr, 'destination IP',        :default => 'random'
  opt :ip_saddr, 'source IP',             :default => 'random'
  opt :payload,  'payload',               :default => 'random'
  opt :type,     'packet type',           :default => 'TCP'
end

opts[:eth_dst]  = Array.new(6) { rand(256).to_s(16).rjust(2, '0') }.join(':') if opts[:eth_dst]  == 'random'
opts[:eth_src]  = Array.new(6) { rand(256).to_s(16).rjust(2, '0') }.join(':') if opts[:eth_src]  == 'random'
opts[:ip_daddr] = Array.new(4) { rand(256) }.join('.')                        if opts[:ip_daddr] == 'random'
opts[:ip_saddr] = Array.new(4) { rand(256) }.join('.')                        if opts[:ip_saddr] == 'random'
opts[:payload]  = rand.to_s                                                   if opts[:payload]  == 'random'

puts "generating #{opts[:count]} #{opts[:type]} packets"
packets = Array.new opts[:count] do
  packet = PacketFu::TCPPacket.new
  packet.eth_dst  = opts[:eth_dst]
  packet.eth_src  = opts[:eth_src]
  packet.ip_daddr = opts[:ip_daddr]
  packet.ip_saddr = opts[:ip_saddr]
  packet.payload  = opts[:payload]
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
