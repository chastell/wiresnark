require 'rubygems'
require 'packetfu'

iface = ARGV.first

cap = PacketFu::Capture.new :iface => iface
cap.show_live
