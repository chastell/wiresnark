expect_packets_at 'lo' do
  count 10

  type 'IIP'

  source_mac      '11:22:33:44:55:66'
  destination_mac 'aa:bb:cc:dd:ee:ff'

  payload 'foo'
end

send_packets_to 'lo' do
  count 10

  type 'IIP'

  source_mac      '11:22:33:44:55:66'
  destination_mac 'aa:bb:cc:dd:ee:ff'

  payload 'foo'
end

verbose
