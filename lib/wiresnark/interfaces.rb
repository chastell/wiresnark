module Wiresnark module Interfaces

  extend self

  def [] name
    interfaces[name] ||= Interface.new name
  end

  private

  def interfaces
    @interfaces ||= {}
  end

end end
