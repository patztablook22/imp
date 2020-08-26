module Phase

  # set log prefix
  # e.g. "retrieving"

  def set str
  end

  # log content
  # e.g. http://git.../file.txt

  def log str
    puts str
  end

  # current status
  # e.g. 69%
  
  def now str
  end

  # fatal error

  def err str = nil
  end

  # minor fail

  def war
  end

  # new entry
  # resets prefix

  def new
  end

end
