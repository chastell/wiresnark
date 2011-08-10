module Wiresnark module DSL module Packet

  [
    :destination_mac,
    :payload,
    :source_mac,
    :type,
  ].each do |name|
    define_method(name) { |value| params[name] = value }
  end

  def count count = nil
    count.nil? ? @count ||= 1 : @count = count
  end

  def params
    @params ||= {}
  end

end end end
