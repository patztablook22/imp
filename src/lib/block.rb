module Phase

  module Block

    COLOR_DEFAULT    = "\e[39m"
    COLOR_RED        = "\e[31m"
    COLOR_GREEN      = "\e[32m"

    @@heap = []
    @@size = 0
    @@data = {
      :message => "",
      :content => [],
      :symbols => [],
    }

    def self.log *args

      message = ""
      content = []
      symbols = []

      message = args.shift

      args.each_with_index do |arg, i|
        if arg.class == Symbol
          symbols << arg
        else
          content << arg
        end
      end

      @@data[:message] = message
      @@data[:content] = content
      @@data[:symbols] = symbols

      render

    end

    def self.end symbol = nil

      return if @@size == 0

      if symbol.class == Symbol
        @@data[:symbols].push(symbol)
      end

      render
      @@size = 0
      puts

    end

    def self.err *args

      self.end :err

      unless $env.keep?
        $env.dump!
        $env.toor!
      end

      $stderr.puts
      $stderr.puts args
      $stderr.puts

      unless @@heap.none?

        $stderr.puts hr(true)

        @@heap.each do |report|
          $stderr.puts report
        end

        $stderr.puts hr(true)

      end

      exit 1

    end

    def self.oki
      self.end :oki
      unless $env.keep?
        $env.dump!
        $env.toor!
      end
    end

    def self.hr suppress = false
      self.end
      buf = "─" * width
      puts buf unless suppress
      buf
    end

    def self.<< report
      @@heap << report
    end

    private

    def self.render

      w    = width
      len  = 0
      buf  = String.new

      default = true
      tmp = {
        :err => COLOR_RED,
        :oki => COLOR_GREEN,
      }

      tmp.each_pair do |sym, col|
        if @@data[:symbols].include? sym
          buf += col
          default = false
        end
      end

      buf += @@data[:message].upcase
      buf += COLOR_DEFAULT unless default
      len += @@data[:message].length

      content = @@data[:content]

      main = content[0]
      meta = content[1]

      unless main.nil?
        buf << " [" << resize(w - buf.size - 5, main) << "]"
      end

      buf << " "

      erase
      @@size = buf.length
      print buf

      puts if $env.verb?

    end

    def self.erase
      print "\b" * @@size + " " * @@size + "\b" * @@size
    end

    def self.resize(len, str)

      len -= 1

      unless str.length > len
        str
      else
        half = len / 2
        str[0..half - 2] + "..." + str[-half..-1]
      end

    end

    def self.width
      pipe = Pipe.new
      pipe.command = "tput cols"
      pipe.go!
      pipe.out.to_i
    end

  end

end
