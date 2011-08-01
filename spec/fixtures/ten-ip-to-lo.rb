expect_packets_at 'lo' do
  count 10

  type 'IP'

  source_mac      '11:22:33:44:55:66'
  destination_mac 'aa:bb:cc:dd:ee:ff'

  source_ip      '1.2.3.4'
  destination_ip '5.6.7.8'

  payload 'foo'
end

send_packets_to 'lo' do
  count 10

  type 'IP'

  source_mac      '11:22:33:44:55:66'
  destination_mac 'aa:bb:cc:dd:ee:ff'

  source_ip      '1.2.3.4'
  destination_ip '5.6.7.8'

  payload 'foo'
end
