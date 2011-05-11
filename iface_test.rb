require 'rubygems'
require 'packetfu'
require 'trollop'

opts = Trollop.options do
  opt :count,     'packet count',          :default => 10
  opt :diface,    'destination interface', :default => 'lo'
  opt :siface,    'source interface',      :default => 'lo'
  opt :eth_daddr, 'destination MAC',       :default => 'random'
  opt :eth_saddr, 'source MAC',            :default => 'random'
  opt :ip_daddr,  'destination IP',        :default => 'random'
  opt :ip_saddr,  'source IP',             :default => 'random'
  opt :payload,   'payload',               :default => 'random'
  opt :sleep,     'seconds to sleep',      :default => 0
  opt :type,      'packet type',           :default => 'TCP'
end

types = ['ARP', 'Eth', 'ICMP', 'IP', 'IPv6', 'TCP', 'UDP']
Trollop.die :type, "must be one of #{types.join ', '}" unless types.include? opts[:type]

opts[:eth_daddr] = Array.new(6) { rand(256).to_s(16).rjust(2, '0') }.join(':') if opts[:eth_daddr] == 'random'
opts[:eth_saddr] = Array.new(6) { rand(256).to_s(16).rjust(2, '0') }.join(':') if opts[:eth_saddr] == 'random'
opts[:ip_daddr]  = Array.new(4) { rand(256) }.join('.')                        if opts[:ip_daddr]  == 'random'
opts[:ip_saddr]  = Array.new(4) { rand(256) }.join('.')                        if opts[:ip_saddr]  == 'random'
opts[:payload]   = rand.to_s                                                   if opts[:payload]   == 'random'

puts "generating #{opts[:count]} #{opts[:type]} packets"
packets = Array.new opts[:count] do
  packet = eval "PacketFu::#{opts[:type]}Packet.new"
  begin
    packet.payload   = opts[:payload]
    packet.eth_daddr = opts[:eth_daddr]
    packet.eth_saddr = opts[:eth_saddr]
    packet.ip_daddr  = opts[:ip_daddr]
    packet.ip_saddr  = opts[:ip_saddr]
  rescue NoMethodError
  end
  packet
end

puts "starting capture on #{opts[:diface]}"
capture = PacketFu::Capture.new :iface => opts[:diface], :start => true

puts "injecting packets into #{opts[:siface]}"
packets.each { |p| p.to_w opts[:siface] }

puts "sleeping #{opts[:sleep]} seconds before ending capture"
sleep opts[:sleep]
capture.save

puts 'GENERATED:'
packets.each { |packet| puts "\t" + packet.peek }

puts 'CAPTURED:'
capture.array.each { |str| puts "\t" + PacketFu::Packet.parse(str).peek }

missing = packets.map(&:to_s) - capture.array
unless missing.empty?
  puts 'MISSING:'
  missing.each { |str| puts "\t" + PacketFu::Packet.parse(str).peek }
end
