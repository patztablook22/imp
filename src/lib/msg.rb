module Msg

  COL_DEFAULT = "\e[39m"
  COL_RED     = "\e[31m"
  COL_GREEN   = "\e[32m"

  ##
  @@data = [
    "", #----------------------------------------------------.
    "", #--------------------------------------.             |
    "", #----------------------.               |             |
  ]#                           |               |             |
  ##                      MESSAGE HEAD  [ message body ]  msg tail
  ##                      ~~~~~~~~~~~~                             
  ##                     <-----|---------------.------------------> 
  ##                           |               |
  @@color = COL_DEFAULT #------'               |
  @@size  = 0           #----------------------'
  ##
  ## errors only
  @@quiet = true
  ##

  def self.quiet= val
    @@quiet = val
  end

  def self.[]= index, str
    for i in (index..2)
      @@data[i] = ""
    end
    @@data[index] = str.to_s
    go! unless index == 0 and true
  end

  def self.err
    col COL_RED
    new
    STDERR.puts Err.s
    exit 1
  end

  def self.oki
    col COL_GREEN
    new
    exit
  end

  def self.del
    num = @@size
    STDERR.print back(num) + " " * num + back(num)
    @@size = 0
  end

  def self.new
    return if @@size == 0
    go! false
    STDERR.puts
    @@size = 0
  end

  def self.col code
    @@color = code
    go!
  end

  def self.go! flag = nil

    return if @@quiet

    if Env["verbose"] >= 3
      pp @@data
      return
    end

    # buffer
    buf = String.new

    # buffer length
    len = 2

    if flag
      buf << "@ "
    else
      buf << "  "
    end

    buf << @@color
    buf << tab(@@data[0], 8 ).upcase
    buf << COL_DEFAULT << " ["
    len += 10

    # add length of @@data[2] and "] "
    len += 4 + 6

    # space left for @@data[1], 3 is cursor etc.
    tmp = width - len - 3

    buf << cut(@@data[1], tmp) << "] "
    buf << cut(@@data[2], 4 )

    del
    STDERR.print buf

    @@size = buf.length

    if Env["verbose"] > 1
      STDERR.puts
      @@size = 0
    end

    # sleep 0.2 if !flag

  end

  def self.width
    pipe = Pipe.go! "tput cols"
    pipe.out.to_i
  end

  def self.back num
    "\b" * num
  end

  def self.tab(str, num, right = false)

    buf = String.new
    str = str.to_s

    if str.length >= num

      buf << str

    else

      tab = " " * (num - str.length)

      buf << tab if  right
      buf << str
      buf << tab if !right

    end

    buf

  end

  def self.cut(str, num)

    buf = String.new
    str = str.to_s

    if str.length > num

      l  = num / 2 - 1
      r  = l
      l -= 1 if l + r + 3 > num

      buf << str[0...l]
      buf << "..."
      buf << str[-r .. -1]

    else

      buf << str

    end

    buf

  end

end
