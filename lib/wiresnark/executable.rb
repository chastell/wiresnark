module Wiresnark class Executable

  def initialize args = ARGV
    opts = Trollop.options args do
      opt :monitor, 'Monitor a given interface.', type: String
    end

    Trollop.die "missing: #{args.reject { |f| File.exists? f }.join ', '}" unless args.all? { |f| File.exists? f }

    @files   = args
    @monitor = opts[:monitor]
  end

  def run output = $stdout
    if @monitor
      Interface.new(@monitor).monitor output
    else
      @files.each { |file| Wiresnark.run file }
    end
  end

end end
