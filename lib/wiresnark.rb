require 'pcaprub'
require 'stringio'
require 'trollop'

require_relative 'wiresnark/dsl'
require_relative 'wiresnark/executable'
require_relative 'wiresnark/generator'
require_relative 'wiresnark/interface'
require_relative 'wiresnark/packet'
require_relative 'wiresnark/packet/dsl'

module Wiresnark

  def self.run file = nil, &block
    @env = Object.new.extend DSL
    @env.instance_eval File.read file if file
    @env.instance_eval &block         if block_given?
    capture_inject_verify
  end

  private

  def self.capture_inject_verify
    output = @env.verbose? ? $stdout : nil

    @env.generations.each do |gen|
      gen[:interface].inject Generator.generate(&gen[:packet_spec]), output
    end

    @env.expectations.each do |exp|
      exp[:interface].verify_capture Generator.generate(&exp[:packet_spec]), output
    end
  end

end
