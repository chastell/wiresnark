module Wiresnark class Executable

  def initialize args
    Trollop.options
    Trollop.die "missing: #{args.reject { |f| File.exists? f }.join ', '}" unless args.all? { |f| File.exists? f }
  end

end end
