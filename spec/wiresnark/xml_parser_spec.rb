require_relative '../spec_helper'

module Wiresnark describe XMLParser do
  let(:xml_parser) { XMLParser.new 'spec/fixtures/iip.conf.xml' }

  describe '#parse' do
    it 'parses the IIP XML config file' do
      hash = xml_parser.parse
      hash[0][:local].must_equal 'ad:e3:3e:a4:23:aa'
      hash[1][:other].must_equal 'a3:aa:45:23:34:aa'
      hash[0][:phases].must_equal [
        { type: 'QOS', length: 180 },
        { type: 'CAN', length: 190 },
        { type: 'DSS', length: 200 },
        { type: 'MGT', length: 210 },
        { type: 'NIL', length: 220 },
      ]
    end
  end

  describe '#verify' do
    it 'returns ignored elements' do
      xml_parser.verify[:ignored].must_equal [
        'BaseValue', 'CBS', 'CIR', 'MACType', 'MACVLAN-tag', 'MTU', 'PIH',
        'SourceAddressfiltering', 'VLAN-TAG', 'VLAN-tagfiltering', 'WFQ', 'ifgap', 'pi',
      ]
    end

    it 'warns on DAF not matching MACDA' do
      xml_parser.verify[:warnings].must_equal [
        'DestinationAddressfiltering (ad:e3:3e:a4:24:aa) =/= MACDestinationAddress (a3:a3:45:23:34:aa)',
        'DestinationAddressfiltering (cd:e3:3e:a4:24:aa) =/= MACDestinationAddress (a3:aa:45:23:34:aa)',
      ]
    end

    it 'warns on Cyclelength and NumberPhases being out of sync with PhaseLength entries' do
      XMLParser.new('spec/fixtures/iip.conf.bad-cyclelength.xml').verify[:warnings].must_equal [
        'Cyclelength (900) =/= sum of PhaseLength (1000)'
      ]
      XMLParser.new('spec/fixtures/iip.conf.bad-numberphases.xml').verify[:warnings].must_equal [
        'NumberPhases (4) =/= number of PhaseLengths (5)'
      ]
    end
  end
end end
