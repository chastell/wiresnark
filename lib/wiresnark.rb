module Wiresnark

  extend self

  def run &block
    instance_eval &block
  end

end
