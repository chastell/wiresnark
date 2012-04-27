module Wiresnark module IIP class Shower
  def initialize net_fpga = NetFPGA.new
    @net_fpga = net_fpga
  end

  def show opts
    param, iface, _, type = *opts

    port = @net_fpga.ports[iface[/\d$/].to_i]

    case param
    when 'CL'    then port.cycle_length
    when 'MACDA' then port.other_mac
    when 'MACSA' then port.local_mac
    when 'MACT'  then "0x#{port.ether_type.to_s 16}"
    when 'MTU'   then port.mtu
    when 'NP'    then port.phase_number
    when 'PIH'   then type ? port.type_map[type].to_s(2).rjust(3, '0') : port.type_map.map { |t, v| "#{t}=#{v.to_s(2).rjust(3, '0')}" }.join(',')
    when 'PL'    then port.phases.map { |p| "#{p[:type]}=#{p[:length]}" if type.nil? or type == p[:type] }.join ','
    when 'ifgap' then port.ifgap
    when 'BV', 'CBS', 'CIR', 'CLASS', 'DAF', 'MACVLANT', 'PIT', 'PIVT', 'SAF', 'VLANTF', 'VPTIin', 'VPTIout', 'WFQ'
      warn "unhandled parameter: #{param}"
    else
      warn "unknown parameter: #{param}"
    end
  end
end end end
