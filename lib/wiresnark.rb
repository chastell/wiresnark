require 'ffi'
require 'nokogiri'
require 'pcaprub'

module Wiresnark
  TypeBytes = {
    'NIL' => 0,
    'DSS' => 1,
    'CAN' => 2,
    'QOS' => 4,
    'MGT' => 7,
  }
end

require_relative 'wiresnark/configuration'
require_relative 'wiresnark/dsl'
require_relative 'wiresnark/executable'
require_relative 'wiresnark/generator'
require_relative 'wiresnark/interface'
require_relative 'wiresnark/packet'
require_relative 'wiresnark/runner'
require_relative 'wiresnark/stream'
