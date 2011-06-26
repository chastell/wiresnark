module Wiresnark

  autoload :DSL,        'wiresnark/dsl'
  autoload :Generator,  'wiresnark/generator'
  autoload :Interfaces, 'wiresnark/interfaces'

  def self.run &block
    DSL.instance_eval &block
  end

end
