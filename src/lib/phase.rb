=begin
module Phase

  include Cycle

  # log content
  # e.g. http://git.../file.txt
  def log str
    Msg[1] = str
    #puts "  | #{str}"
  end

  # current status
  # e.g. 69%
  def now str
    Msg[2] = str
  end

end
=end
