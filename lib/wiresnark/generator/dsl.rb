module Wiresnark module Generator::DSL

  {
    count:           1,
    destination_mac: '00:00:00:00:00:00',
    payload:         nil,
    source_mac:      '00:00:00:00:00:00',
    type:            'Eth',
  }.each do |method, default|
    define_method method do |value = nil|
      ivar = :"@#{method}"
      case
      when value                       then instance_variable_set ivar, value
      when instance_variable_get(ivar) then instance_variable_get ivar
      else                                  instance_variable_set ivar, default
      end
    end
  end

end end
