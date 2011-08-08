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

  def self.run &block
    @env = Object.new.extend DSL
    @env.instance_eval &block
    capture_inject_verify
  end

  def self.run_file file
    @env = Object.new.extend DSL
    @env.instance_eval File.read file
    capture_inject_verify
  end

  private

  def self.capture_inject_verify
    output = @env.verbose? ? $stdout : StringIO.new

    @env.generations.each do |gen|
      gen[:interface].inject Generator.generate(&gen[:packet_spec]), output
    end

    @env.expectations.each do |exp|
      exp[:interface].verify_capture Generator.generate(&exp[:packet_spec]), output
    end
  end

end
