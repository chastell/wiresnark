require 'packetfu'

require_relative 'wiresnark/dsl'
require_relative 'wiresnark/generator'
require_relative 'wiresnark/interface'
require_relative 'wiresnark/packet'
require_relative 'wiresnark/packet/dsl'

module Wiresnark

  def self.run &block
    env = Object.new.extend DSL
    env.instance_eval &block
    env.expectations.each do |exp|
      exp[:interface].expect Generator.generate &exp[:packet_spec]
    end
    env.generations.each do |gen|
      gen[:interface].inject Generator.generate &gen[:packet_spec]
    end
  end

end
