module Wiresnark module DSL module PacketDSL
  [
    :destination_mac,
    :min_size,
    :payload,
    :random_size,
    :source_mac,
    :type,
  ].each do |name|
    define_method(name) { |value| params[name] = value }
  end

  def params
    @params ||= {}
  end
end end end
