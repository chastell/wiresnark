require 'rubygems'
require 'packetfu'

number = ARGV.first.to_i
iface  = ARGV.last

puts "writing #{number} packets to #{iface}"

number.times do
  packet = PacketFu::TCPPacket.new
  packet.ip_saddr = [rand(256), rand(256), rand(256), rand(256)].join '.'
  packet.ip_daddr = [rand(256), rand(256), rand(256), rand(256)].join '.'
  packet.payload  = rand.to_s
  packet.to_w iface
end
