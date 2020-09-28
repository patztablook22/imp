module Cli

  extend  self

  DEFAULT = "\e[39m"
  RED     = "\e[31m"
  GREEN   = "\e[32m"

  @@data = [
    "", #----------------------------------------------------.
    "", #--------------------------------------.             |
    "", #----------------------.               |             |
  ]#                           |               |             |
  ##                      MESSAGE HEAD  [ message body ]  msg tail
  ##                      ~~~~~~~~~~~~                             
  ##                     <-----|---------------.------------------> 
  ##                           |               |
  @@color = DEFAULT #----------'               |
  @@size  = 0       #--------------------------'
  ##
  ## errors only
  @@quiet = true
  ##
  
  # supress messages
  def quiet= val
    @@quiet = val
  end

  # update message
  #
  # Msg[-1] = "general"  => unstructurized print
  # Msg[0]  = "collect"  => update head
  # Msg[1]  = "bananas"  => update body
  #
  def []= index, str
    if index == -1
      del
      puts str unless Env["debug"]
    else
      for i in (index..2)
        @@data[i] = ""
      end
      @@data[index] = str.to_s
      go! unless index == 0 and true
    end
  end

  def err
    col RED
    new
    errs = Err.s
    STDERR.puts errs unless errs.empty?
    App.quit 1
  end

  def oki
    col GREEN
    new
    App.quit
  end

  def del
    num = @@size
    STDERR.print back(num) + " " * num + back(num)
    @@data = Array.new(3, "")
    @@size = 0
  end

  def new
    return if @@size == 0
    go!
    STDERR.puts
    @@size = 0
  end

  def col code
    @@color = code
    go!
  end

  def go!

    return if @@quiet or Env["debug"]

    return if @@data[0].empty?

    if Env["verbose"] >= 3
      pp @@data
      return
    end

    # buffer
    buf = String.new

    # buffer length
    len = 0

    buf << @@color
    buf << tab(@@data[0], 8 ).upcase
    buf << DEFAULT << " ["
    len += 10

    # add length of @@data[2] and "] "
    len += 4 + 6

    # space left for @@data[1], 3 is cursor etc.
    tmp = width - len - 3

    buf << cut(@@data[1], tmp) << "] "
    buf << cut(@@data[2], 4 )
    data = @@data

    del
    STDERR.print buf

    @@size = buf.length
    @@data = data

    if Env["verbose"] > 1
      STDERR.puts
      @@size = 0
    end

  end

  def back num
    "\b" * num
  end

  def tab(str, num, right = false)

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

  def cut(str, num)

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

  def width
    STDERR.winsize[1]
  end

  def hr
    STDERR.puts "─" * width
  end

  def clear
    STDERR.clear_screen
  end

  def tab str, num, right = false
    str = str.to_s
    return str if str.length >= num
    buf = String.new
    buf << str if !right
    buf << " " * (num - str.length)
    buf << str if  right
    buf
  end

end
