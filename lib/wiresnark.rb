module Wiresnark

  autoload :DSL, 'wiresnark/dsl'

  def self.run &block
    DSL.instance_eval &block
  end

end
