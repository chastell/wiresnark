module Wiresnark class Executable

  def initialize args = ARGV
    Trollop.options
    Trollop.die "missing: #{args.reject { |f| File.exists? f }.join ', '}" unless args.all? { |f| File.exists? f }
    @files = args
  end

  def run
    @files.each { |file| Wiresnark.run_file file }
  end

end end
