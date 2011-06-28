require_relative 'wiresnark/dsl'
require_relative 'wiresnark/generator'
require_relative 'wiresnark/generator/dsl'
require_relative 'wiresnark/interface'
require_relative 'wiresnark/interfaces'
require_relative 'wiresnark/packet'

module Wiresnark

  def self.run &block
    DSL.instance_eval &block
  end

end
