module Wiresnark class Packet

  [:payload, :type].each do |name|
    define_method(name) { params[name] }
  end

  def initialize opts = {}
    params.merge! opts
  end

  def == other
    params == other.params
  end

  alias eql? ==

  def hash
    params.hash
  end

  protected

  def params
    @params ||= {
      payload: '',
      type:    'Eth',
    }
  end

end end
