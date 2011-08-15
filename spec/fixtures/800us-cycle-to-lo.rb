send_cycle_to 'lo' do
  phase_usecs 200
  phase_types 'QoS', 'CAN', 'DSS', 'MGT'
  payload :sequence
end
