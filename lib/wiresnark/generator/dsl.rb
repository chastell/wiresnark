module Wiresnark module Generator::DSL

  def count count = nil
    count ? @count = count : @count ||= 1
  end

  def destination_mac mac = nil
    mac ? @destination_mac = mac : @destination_mac ||= '00:00:00:00:00:00'
  end

  def payload payload = nil
    payload ? @payload = payload : @payload
  end

  def source_mac mac = nil
    mac ? @source_mac = mac : @source_mac ||= '00:00:00:00:00:00'
  end

  def type type = nil
    type ? @type = type : @type ||= 'Eth'
  end

end end
