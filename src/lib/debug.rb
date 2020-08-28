module Debug

  @@active

  # print debug message (if set on)
  #
  # Debug> @file
  # Debug> processed(@file)
  #
  def self.> str
    return unless @@active
    STDERR.puts "_" * 48
    STDERR.puts
    STDERR.puts str
    exit
  end

  # debug head
  # 
  # Debug.h "processing files"
  #
  def self.h str
    return unless @@active
    STDERR.puts str
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
    STDERR.puts str
    true
  end

end
