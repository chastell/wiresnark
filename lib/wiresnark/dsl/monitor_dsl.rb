module Wiresnark module DSL module MonitorDSL
  include CommonDSL

  def running_tally
    @running_tally = true
  end

  def running_tally?
    @running_tally ||= false
    @running_tally
  end
end end end
