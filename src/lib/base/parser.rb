class Parser

  attr_reader :data
  @data
  @type
  @term
  @buff
  @comment

  def initialize path

    file = File.open(path, 'r') rescue return

    @data = Hash.new
    @buff = [""]

    file.each_char do |ch|
      push ch
    end

    format

  end

  private
  
  def push ch

    case ch
    when "#"
      @comment = true
      return
    when "\n"
      @comment = false
      return if @buff.size == 1
    else
      return if @comment
    end

    case @buff.size
    when 1

      case ch
      when "="

        @type = :constant
        @term = nil
        @buff+= [""]

      when "{"

        @type = :function
        @term = 0
        @buff+= [""]

      when " "
      else

        @buff[0] += ch

      end

    when 2

      if @type == :constant # constant

        if @term == nil
          if ch == "("
            @term = ")"
          else
            @term = "\n"
            @buff[1] += ch
          end
        else
          if ch == @term
            @data[@buff[0]] = @buff[1]
            @buff = [""]
          else
            @buff[1] += ch
          end
        end 

      else # function

        case ch
        when "{"
          @term += 1
          @buff[1] += ch
        when "}"
          if @term > 0
            @term -= 1
            @buff[1] += ch
          else
            @data[@buff[0]] = @buff[1]
            @buff = [""]
          end
        else
          @buff[1] += ch
        end

      end

    end

  end

  def format

    buff = Hash.new
    @data.each_pair do |key, val|

      if key.end_with? "()"
        val = [val]
      else
        tmp = val.split(/ "| '|' |" |\n/)
        val = []
        tmp.each do |it|
          it.strip!
          next if it.empty?
          it.delete! ?"
          it.delete! ?'
          val += [it]
        end
      end

      buff[key] = val

    end

    @data = buff

  end

end
