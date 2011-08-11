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

  def phase_types *phase_types
    phase_types.empty? ? @phase_types ||= ['Eth'] : @phase_types = phase_types
  end

  def phase_usec phase_usec = nil
    phase_usec.nil? ? @phase_usec ||= 1000 : @phase_usec = phase_usec
  end

end end end
