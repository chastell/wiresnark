module Wiresnark class Runner
  def run file, env = Object.new.extend(DSL::WiresnarkDSL)
    env.instance_eval File.read file

    env.generator_blocks.each do |block|
      gen = Object.new.extend DSL::GeneratorDSL
      gen.instance_eval &block

      iface  = Interface.new gen.interface
      output = gen.verbose? ? $stdout : nil

      case
      when gen.count
        iface.inject Generator.generate(gen), output
      when gen.phase_usecs
        phase_times = Hash[gen.phase_types.zip gen.phase_usecs]
        phase_pckts = Hash[gen.phase_types.map { |type| [gen.type(type), Generator.generate(gen, phase_times[type])] }]
        phase_times.cycle(gen.cycles) do |type, time|
          stop = Time.now + (time / 1_000_000.0)
          catch :next_type do
            phase_pckts[type].cycle do |packet|
              iface.inject [packet], output
              throw :next_type if Time.now > stop
            end
          end
        end
      end
    end

    env.monitor_blocks.each do |block|
      mon = Object.new.extend DSL::MonitorDSL
      mon.instance_eval &block

      # FIXME: deuglify the below
      counts = Hash[TypeBytes.keys.map { |type| [type, { bytes: 0,  count: 0 }]}]
      type = nil
      Interface.new(mon.interface).stream.each do |bin|
        packet = Packet.new bin

        if type and packet.type != type
          puts "\t#{counts[type][:count]} #{type}\t#{counts[type][:bytes]} bytes\t#{counts[type][:bytes] / counts[type][:count]} bytes/packet\n\n" unless mon.running_tally?
          counts[packet.type] = { bytes: 0, count: 0 }
        end

        type = packet.type
        counts[type][:bytes] += packet.size
        counts[type][:count] += 1

        puts "#{mon.interface} ->\t#{packet}" if mon.verbose?

        if mon.running_tally?
          print "\r" + counts.map { |t, vals| "#{t}: #{vals[:count].to_s.rjust 5} p, #{vals[:bytes].to_s.rjust 5} b, #{(vals[:bytes] / vals[:count] rescue nil).to_s.rjust 5} b/p" }.join('    ')
        end
      end

      puts "\t#{counts[type][:count]} #{type}\t#{counts[type][:bytes]} bytes\t#{counts[type][:bytes] / counts[type][:count]} bytes/packet\n\n" unless mon.running_tally?
      puts if mon.running_tally?
    end
  end
end end
