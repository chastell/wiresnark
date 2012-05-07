module Wiresnark module DSL::MonitorDSL
  include DSL::CommonDSL

  def running_tally
    @running_tally = true
  end

  def running_tally?
    @running_tally ||= false
    @running_tally
  end
end end
