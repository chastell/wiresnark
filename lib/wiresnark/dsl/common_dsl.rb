module Wiresnark module DSL module CommonDSL
  def interface interface = nil
    @interface ||= nil
    interface.nil? ? @interface : @interface = interface
  end

  def verbose
    @verbose = true
  end

  def verbose?
    @verbose ||= false
  end
end end end
