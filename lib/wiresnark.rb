module Wiresnark

  autoload :DSL,        'wiresnark/dsl'
  autoload :Generator,  'wiresnark/generator'
  autoload :Interface,  'wiresnark/interface'
  autoload :Interfaces, 'wiresnark/interfaces'

  def self.run &block
    DSL.instance_eval &block
  end

end
