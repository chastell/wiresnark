require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/pride'
require 'stringio'

require_relative '../lib/wiresnark'

MiniTest::Spec.before do
  Wiresnark::Configuration.payload_bytes = 5
  Wiresnark::Stream.instance_variable_set :@streams, {}
end
