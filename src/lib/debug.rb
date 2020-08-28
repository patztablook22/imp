require_relative 'msg'

module Debug

  @@active = false    # debug mode active
  @@used   = false    # has it been used?

  # print debug message (if set on)
  #
  # Debug> @file
  # Debug> processed(@file)
  #
  def self.> str

    return unless @@active
    unless @@used
      @@used = true
      STDERR.puts
      STDERR.puts
      STDERR.puts "IMP DEBUG"
      STDERR.puts "─" * Msg.width
      STDERR.puts
    end

    pp str

  end

  # set debug mode
  def self.set bool
    @@active = bool
  end

  # get debug mode
  def self.get
    @@active
  end

  # set debug hook
  def self.hook str
    return false unless @@active
    if @@used
      puts
      exit 3
    end
    STDERR.puts str
    true
  end

end
