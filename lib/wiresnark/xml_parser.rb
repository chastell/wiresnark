module Wiresnark class XMLParser
  DefaultMAC  = '00:00:00:00:00:00'
  ValidIface  = /\Aeth\d\Z/
  ValidMAC    = /\A\h\h(:\h\h){5}\Z/
  ValidNumber = /\A\d+\Z/

  def initialize path
    @xml = Nokogiri::XML File.read path
  end

  def parse
    Hash[@xml.xpath('/interfaces/interface').map do |interface|
      macsa = interface.at_xpath('v_port/MACSourceAddress/text()').to_s
      macda = interface.at_xpath('v_port/MACDestinationAddress/text()').to_s
      local = macsa =~ ValidMAC ? macsa : DefaultMAC
      other = macda =~ ValidMAC ? macda : DefaultMAC

      phases = interface.xpath('Scheduler/PhaseLength').map { |p| { type: p.attr('pi'), length: p.text.to_i } }
      [interface.attr('name').chars.to_a.last.to_i, { local: local, other: other, phases: phases }]
    end]
  end

  def warnings
    private_methods.grep(/^warn_/).map { |meth| send meth }.flatten.compact
  end

  private

  def warn_daf_macda
    @xml.xpath('/interfaces/interface/v_port').map do |v_port|
      if v_port.at_xpath 'DestinationAddressfiltering'
        daf   = v_port.at_xpath('DestinationAddressfiltering/text()').to_s
        macda = v_port.at_xpath('MACDestinationAddress/text()').to_s
        "DestinationAddressfiltering (#{daf}) =/= MACDestinationAddress (#{macda})" unless daf == macda
      end
    end
  end

  def warn_cl_sum_of_pl
    @xml.xpath('/interfaces/interface/Scheduler[@type = "XenNet"]').map do |scheduler|
      if scheduler.at_xpath 'Cyclelength'
        cl     = scheduler.at_xpath('Cyclelength/text()').to_s.to_i
        pl_sum = scheduler.xpath('PhaseLength/text()').map { |pl| pl.to_s.to_i }.inject :+
        "Cyclelength (#{cl}) =/= sum of PhaseLength (#{pl_sum})" unless cl == pl_sum
      end
    end
  end

  def warn_iface_format
    @xml.xpath('//interface').map do |iface|
      "bad interface name: #{iface.attr 'name'}" unless iface.attr('name') =~ ValidIface
    end
  end

  def warn_ignored
    parsed = [
      'interfaces', 'interface', 'v_port', 'Scheduler',
      'DestinationAddressfiltering', 'MACDestinationAddress', 'MACSourceAddress',
      'Cyclelength', 'NumberPhases', 'PhaseLength',
    ]
    (@xml.xpath('//*').map(&:name) - parsed).map { |w| "#{w} ignored" }
  end

  def warn_mac_format
    @xml.xpath('//MACDestinationAddress | //MACSourceAddress').map do |element|
      "bad #{element.name}: #{element.text}" unless element.text =~ ValidMAC
    end
  end

  def warn_mac_missing
    @xml.xpath('/interfaces/interface/v_port').map do |v_port|
      ['MACDestinationAddress', 'MACSourceAddress'].map do |mac|
        "#{mac} set to #{DefaultMAC}" unless v_port.at_xpath mac
      end
    end
  end

  def warn_np_number_of_pl
    @xml.xpath('/interfaces/interface/Scheduler[@type = "XenNet"]').map do |scheduler|
      if scheduler.at_xpath 'NumberPhases'
        np     = scheduler.at_xpath('NumberPhases/text()').to_s.to_i
        pl_num = scheduler.xpath('PhaseLength').size
        "NumberPhases (#{np}) =/= number of PhaseLengths (#{pl_num})" unless np == pl_num
      end
    end
  end

  def warn_number_format
    @xml.xpath('//Cyclelength | //NumberPhases | //PhaseLength').map do |element|
      "bad #{element.name}: #{element.text}" unless element.text =~ ValidNumber
    end
  end

  def warn_pi_format
    @xml.xpath('//PhaseLength').map do |pl|
      "bad PhaseLength pi: #{pl.attr 'pi'}" unless TypeBytes.keys.include? pl.attr 'pi'
    end
  end

  def warn_pl_rounding
    @xml.xpath('/interfaces/interface/Scheduler[@type = "XenNet"]/PhaseLength/text()').map do |pl|
      pl      = pl.to_s.to_i
      rounded = pl / NetFPGA::Port::LengthUnit * NetFPGA::Port::LengthUnit
      "PhaseLength of #{pl} ns will be rounded to #{rounded} ns" unless pl == rounded
    end
  end
end end
