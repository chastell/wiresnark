module Wiresnark module DSL module GeneratorDSL
  include CommonDSL, PacketDSL

  def count count = nil
    @count ||= nil
    count.nil? ? @count : @count = count
  end

  def cycles cycles = nil
    @cycles ||= nil
    cycles.nil? ? @cycles : @cycles = cycles
  end

  def phase_types *phase_types
    @phase_types ||= nil
    phase_types.empty? ? @phase_types : @phase_types = phase_types
  end

  def phase_usecs *phase_usecs
    @phase_usecs ||= nil
    phase_usecs.empty? ? @phase_usecs : @phase_usecs = phase_usecs
  end

  def sequence
    @sequence = true
  end

  def sequence?
    @sequence ||= false
  end
end end end
