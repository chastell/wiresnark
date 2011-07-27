module Wiresnark module Generator::DSL

  private

  def self.dsl_attr name, default = nil
    define_method name do |value = nil|
      ivar = :"@#{name}"
      case
      when value                       then instance_variable_set ivar, value
      when instance_variable_get(ivar) then instance_variable_get ivar
      else                                  instance_variable_set ivar, default
      end
    end
  end

  public

  dsl_attr :count,           1
  dsl_attr :destination_mac, '00:00:00:00:00:00'
  dsl_attr :source_mac,      '00:00:00:00:00:00'
  dsl_attr :type,            'Eth'
  dsl_attr :payload

end end
