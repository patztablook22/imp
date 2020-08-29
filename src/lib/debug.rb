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
      Term.hr
      STDERR.puts
    end

    pp str

  end

  # set debug mode
  def self.on!
    @@active = true
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
