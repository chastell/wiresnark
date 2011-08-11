require 'pcaprub'
require 'stringio'
require 'trollop'

require_relative 'wiresnark/dsl/packet'
require_relative 'wiresnark/dsl/wiresnark'
require_relative 'wiresnark/executable'
require_relative 'wiresnark/generator'
require_relative 'wiresnark/interface'
require_relative 'wiresnark/packet'

module Wiresnark

  def self.run file = nil, &block
    @env = Object.new.extend DSL::Wiresnark
    @env.instance_eval File.read file if file
    @env.instance_eval &block         if block_given?
    inject_and_verify
  end

  private

  def self.inject_and_verify
    output = @env.verbose? ? $stdout : nil

    @env.send_packets_to_blocks.each do |send|
      send[:interface].inject Generator.generate(&send[:packet_spec]), output
    end

    @env.expect_packets_at_blocks.each do |exp|
      exp[:interface].verify_capture Generator.generate(&exp[:packet_spec]), output
    end
  end

end
