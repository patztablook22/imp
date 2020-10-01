# frozen_string_literal: true
class Input < Block

  @@clip = ''

  def initialize
    @curs = 0
    @left = 0
    @data = ''
    @hint = ''
  end

  def focus
    App.navi 'ENTER' => 'search'
  end

  def update data
    @hint = data.to_s
    super
  end

  def key ch

    case ch
    when :key_down
      App.focus 'result'
      return
    when :key_left
      return if @curs == 0
      @curs -= 1
    when :key_right
      return if @curs == @data.length
      @curs += 1
    when :backspace
      return if @curs == 0
      @data[@curs - 1] = ''
      @curs -= 1
    when :delete
      return if @curs == @data.length
      @data[@curs] = ''
    when :enter
      App.result nil
      Plugin.search @data do |res|
        App.result res
      end
    when 1
      @curs = 0
    when 5
      @curs = @data.length
    when 21
      @@clip = @data[0...@curs]
      @data[0...@curs] = ''
      @curs = 0
    when 23
    when 25
      @data.insert(@curs, @@clip)
      @curs += @@clip.length
    when 12
      App.result nil
    when Integer
      return if ch < 32
      @data.insert(@curs, ch.chr)
      @curs += 1
    end
    display
  end

  def click pos
    @curs = [ @left + pos[1], @data.length ].min
    true
  end

  def display

    super

    if @data.empty?
      Curses.attron(Curses.color_pair(4))
      out @hint
      Curses.attroff(Curses.color_pair(4))
      move [0, 0]
      out '', false
    else

      if @curs - @left > @w
        @left = @curs - @w
      elsif @left > @curs
        @left = @curs
      end

      out @data[@left..@left + @w]
      move [0, @curs - @left]
      out '', false

    end

  end

end
