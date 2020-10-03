require_relative 'frame'

class Popup < Frame

  attr_reader :head

  def key ch
    case ch
    when :key_right
      @index += 1 unless @index == @actions.size - 1
      display
    when :key_left
      @index -= 1 unless @index == 0
      display
    when :enter
      App.pupop
      @actions.values[@index]&.call
    when :escape
      @actions.values[0].call if @actions.size == 1
      App.pupop
    end
  end

  def initialize
    super
    @index   = 0
    @actions = {}
  end

  def update *data
    @head    = data[0]
    @body    = data[1]
    @actions = data[2]
    @actions = { false => @actions } if @actions.class == Proc
  end

  def click pos

    return unless pos[0] == @h - 3
    return if @actions.size < 2
    pos = pos[1]

    if [ [true, false], [false, true] ].include? @actions.keys

      pos += 13 - @w

      if pos < 0
        return
      elsif pos < 5
        opt = 0
      elsif pos < 9
        opt = 1
      else
        return
      end

      App.pupop
      @actions.values[opt].call if opt
      return

    else

      len  = @actions.keys.max { |a, b| a.length <=> b.length }.length
      pos += len + 8 - @w

      if pos < 0
      elsif pos == 0
        key :key_left
      elsif pos <= len + 2
        key :enter
      elsif pos == len + 3
        key :key_right
      end
      
    end

  end

  def scroll lines
  end

  def display

    reset
    super

    move [2, 3]

    Curses.attron Curses::A_BOLD
    out @head.upcase, false
    Curses.attroff Curses::A_BOLD

    number = 0
    @body.each_line do |line|
      line.strip!
      next if line.empty?
      if line.length > @w - 6
        line = line[0..@w - 10] + '...'
      end
      move [4 + number, 3]
      out line, false
      number += 1
    end

    if @actions.size < 2

      return

    elsif [ [true, false], [false, true] ].include? @actions.keys

      move [ -3, -13 ]

      @actions.keys.each_with_index do |opt, index|

        opt = case opt
              when true;  'YES'
              when false; 'NO'
              end

        if @index == index
          Curses.attron Curses.color_pair 3
          Curses.attron Curses::A_BOLD
          out "[#{opt}]", false
          Curses.attroff Curses::A_BOLD
          Curses.attroff Curses.color_pair 3
        else
          Curses.attron Curses.color_pair 2
          Curses.attron Curses::A_DIM
          out " #{opt} ", false
          Curses.attroff Curses::A_DIM
          Curses.attroff Curses.color_pair 2
        end

      end

    else

      opt = @actions.keys[@index].upcase
      len = @actions.keys.max { |a, b| a.length <=> b.length }.length
      move [ -3, -5 - len - 3 ]

      Curses.attron Curses.color_pair 2
      if @index == 0
        out ' ', false
      else
        out '<', false
      end
      Curses.attroff Curses.color_pair 2

      Curses.attron Curses.color_pair 3
      Curses.attron Curses::A_BOLD
      out " #{opt}#{ " " * (len - opt.length) } ", false
      Curses.attroff Curses::A_BOLD
      Curses.attroff Curses.color_pair 3

      Curses.attron Curses.color_pair 2
      if @index == @actions.size - 1
        out ' ', false
      else
        out '>', false
      end
      Curses.attroff Curses.color_pair 2

    end

  end

end
