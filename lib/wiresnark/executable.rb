module Wiresnark class Executable
  def initialize args = ARGV
    @command = args.shift
    @args    = args
  end

  def run opts = { runner: Runner.new }
    case command
    when 'run'
      opts[:runner].run args.first
    end
  end

  attr_reader :args, :command
  private     :args, :command
end end
