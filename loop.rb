require 'rubygems'
require 'packetfu'

count = ARGV.first.to_i
iface = ARGV.last

puts "generating #{count} packets…"
packets = (1..count).map do
  packet = PacketFu::TCPPacket.new
  packet.ip_saddr = [rand(256), rand(256), rand(256), rand(256)].join '.'
  packet.ip_daddr = [rand(256), rand(256), rand(256), rand(256)].join '.'
  packet.payload  = rand.to_s
  packet.to_s
end

puts 'starting capture…'
capture = PacketFu::Capture.new :iface => iface
capture.start

puts 'injecting packets…'
inject = PacketFu::Inject.new :iface => iface
inject.array_to_wire :array => packets

capture.save

puts "#{packets.size} generated, #{capture.array.size} captured"
if (packets - capture.array).empty?
  puts 'all generated captured!'
else
  puts 'not all generated captured!'
end
