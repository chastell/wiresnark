module Wiresnark class Packet

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
