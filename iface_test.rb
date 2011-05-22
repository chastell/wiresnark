#!/usr/bin/env ruby

require 'rubygems'
require 'packetfu'
require 'trollop'

opts = Trollop.options do
  opt :count,      'packet count',          :default => 10
  opt :diface,     'destination interface', :default => 'lo'
  opt :siface,     'source interface',      :default => 'lo'
  opt :eth_daddr,  'destination MAC',       :default => 'random'
  opt :eth_saddr,  'source MAC',            :default => 'random'
  opt :ip_daddr,   'destination IP',        :default => 'random'
  opt :ip_saddr,   'source IP',             :default => 'random'
  opt :ipv6_daddr, 'destination IPv6',      :default => 'random'
  opt :ipv6_saddr, 'source IPv6',           :default => 'random'
  opt :payload,    'payload',               :default => 'random'
  opt :sleep,      'seconds to sleep',      :default => 0
  opt :type,       'packet type',           :default => 'TCP'

  nf_defaults = ['eth1', 'eth2', 'nf2c3', 'nf2c2']
  (0..3).each do |x|
    ['local', 'other'].each do |mac|
      opt :"nf2c#{x}_#{mac}", "#{mac} nf2c#{x} MAC or iface to copy from", :default => mac == 'local' ? "nf2c#{x}" : nf_defaults[x], :short => :none
    end
  end
end

types = ['ARP', 'Eth', 'ICMP', 'IP', 'IPv6', 'TCP', 'UDP']
Trollop.die :type, "must be one of #{types.join ', '}" unless types.include? opts[:type]

opts[:eth_daddr]  = Array.new(6) { rand(256).to_s(16).rjust(2, '0') }.join(':')   if opts[:eth_daddr]  == 'random'
opts[:eth_saddr]  = Array.new(6) { rand(256).to_s(16).rjust(2, '0') }.join(':')   if opts[:eth_saddr]  == 'random'
opts[:ip_daddr]   = Array.new(4) { rand(256) }.join('.')                          if opts[:ip_daddr]   == 'random'
opts[:ip_saddr]   = Array.new(4) { rand(256) }.join('.')                          if opts[:ip_saddr]   == 'random'
opts[:ipv6_daddr] = Array.new(8) { rand(65536).to_s(16).rjust(4, '0') }.join(':') if opts[:ipv6_daddr] == 'random'
opts[:ipv6_saddr] = Array.new(8) { rand(65536).to_s(16).rjust(4, '0') }.join(':') if opts[:ipv6_saddr] == 'random'
opts[:payload]    = rand.to_s                                                     if opts[:payload]    == 'random'


((0..3).map { |x| ['local', 'other'].map { |loc| :"nf2c#{x}_#{loc}" }}.flatten + [:eth_daddr, :eth_saddr]).each do |option|
  unless opts[option] =~ /^([\da-f]{2}:){5}[\da-f]{2}$/
    begin
      opts[option] = File.read("/sys/class/net/#{opts[option]}/address").chomp
    rescue Errno::ENOENT
      Trollop.die option, "no such device: #{opts[option]}"
    end
  end
end

[:ip_daddr, :ip_saddr].each do |option|
  unless opts[option] =~ /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/
    begin
      opts[option] = `ifconfig #{opts[option]}`.match(/inet addr:(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/)[1].to_s
    rescue NoMethodError
      Trollop.die option, "no such device or device not configured: #{opts[option]}"
    end
  end
end

puts "generating #{opts[:count]} #{opts[:type]} packets"
packets = Array.new opts[:count] do
  packet = eval "PacketFu::#{opts[:type]}Packet.new"
  packet.payload    = opts[:payload]
  packet.eth_daddr  = opts[:eth_daddr]
  packet.eth_saddr  = opts[:eth_saddr]
  packet.ip_daddr   = opts[:ip_daddr]   if packet.is_ip?
  packet.ip_saddr   = opts[:ip_saddr]   if packet.is_ip?
  packet.ipv6_daddr = opts[:ipv6_daddr] if packet.is_ipv6?
  packet.ipv6_saddr = opts[:ipv6_saddr] if packet.is_ipv6?
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

missing = packets.map { |p| p.to_s } - capture.array
unless missing.empty?
  puts 'MISSING:'
  missing.each { |str| puts "\t" + PacketFu::Packet.parse(str).peek }
end
