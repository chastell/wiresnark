module Wiresnark module Generator::DSL

  def count count = nil
    count ? @count = count : @count ||= 1
  end

  def type type = nil
    type ? @type = type : @type ||= 'Eth'
  end

end end
