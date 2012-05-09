require 'ffi'
require 'nokogiri'
require 'pcaprub'

module Wiresnark
  module DSL
  end

  class NetFPGA
  end

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
require_relative 'wiresnark/iip/committer'
require_relative 'wiresnark/iip/config_parser'
require_relative 'wiresnark/iip/getter'
require_relative 'wiresnark/iip/shower'
require_relative 'wiresnark/interface'
require_relative 'wiresnark/net_fpga'
require_relative 'wiresnark/packet'
require_relative 'wiresnark/reg_parser'
require_relative 'wiresnark/runner'
require_relative 'wiresnark/stream'
