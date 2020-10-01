# frozen_string_literal: true
require_relative 'cache'
require_relative 'block'

module App

  extend self

  @@tui    = nil   # tui mode?

  def tui?
    @@tui == true
  end

  @@blocks = {     # main blocks
    "search"   => Input   .new,
    "result"   => Result  .new,
    "debug"    => Debug   .new,
    "intro"    => Intro   .new,
    "log"      => Log     .new,
  }

  @@tabs   = {
    "intro"    => @@blocks["intro"],
    "search"   => Tab.new,
    "install"  => Tab.new,
    "plugin"   => Tab.new,
  }

  @@frames = Array.new(3, Frame.new)
  @@popups = Array.new

  @@navi   = Navi .new
  @@focus  = Array.new  # focused block history

  def init tui

    if Curses.nil? and tui
      Cli[-1] = "missing curses library"
      Cli[-1] = "either use CLI or try"
      Cli[-1] = "imp --upgrade"
      exit 1
    end

    tui = false unless STDOUT.tty?
    return unless @@tui = tui

    Curses.start_color
    Curses.use_default_colors
    Curses.init_color(2,  220, 220, 220) # grey
    Curses.init_color(3,  331, 330, 330) # smoke grey
    Curses.init_color(4, 1000, 700,   0) # orange
    Curses.init_pair(2, 4,  2)           # orange on grey
    Curses.init_pair(3, 2,  4)           # grey on orange
    Curses.init_pair(4, 3, -1)           # grey on default
    Curses.init_pair(5, 4, -1)           # orange on default
    Curses.curs_set 0
    Curses.mousemask Curses::ALL_MOUSE_EVENTS
    Curses.raw
    Curses.cbreak
    Curses.noecho

    search "search remote packages"
    navi.display
    set
    focus @@focus[-1]

    Curses.init_screen
    Thread.new do input end

  end

  def quit status = 0
    exit status unless tui?
    exit status if @@popups.any? { |it| it.head == "quit" }
    App.popup "quit", "Quit imp?", {
      true  => -> { exit status },
      false => -> {},
    }
  end

  def popup head, body, actions = Hash.new
    return unless tui?
    @@popups << Popup.new
    @@focus  << @@popups[-1]
    @@focus[-1].update head, body, actions
    set
  end

  def pupop
    return false if @@popups.none?
    @@popups.pop
    @@focus.pop
    set
    return true
  end

  @@tab = ""
  def tab name

    return unless @@tabs.include? name
    
    @@tab = name

    @@tabs.each do |key, val|
      val.hide = key != name
    end

    set

    case name
    when "intro"
      focus "intro"
    when "search"
      focus "search"
    when "install"
      focus "log"
    end

    App.render

  end

  def navi data = nil
    @@navi.update data
  end

  def method_missing m, data = nil
    @@blocks[m.to_s].update data
  end

  def focus target = nil
    unless target.class&.superclass == Block
      return unless @@blocks.include? target
      target = @@blocks[target]
    end
    return if target.hide?
    if @@focus.any?
      @@focus[-1].unfocus
      @@focus[-1] = target
    else
      @@focus << target
    end
    return unless tui?
    target.focus
    render
  end

  def render
    return unless tui?
    @@focus[-1]&.display
    Curses.curs_set 0
    Curses.refresh
    Curses.curs_set 1 if [Input, Log].include? @@focus[-1].class
  end

  def set

    return unless tui?

    size  = STDOUT.winsize
    halfL = [ 0, size[1] / 2 - 1 ]
    halfR = [ 1, size[1] / 2 + 1 ]

    Curses.resize *size
    Curses.erase

    @@tabs["intro"].set( [0, 0], [ size[0] - 2, size[1] ] )

    @@tabs["search"].set( [0, 0], [ size[0] - 2, size[1] ] ) do
      @@frames[0].set( [2, 0], [3, 0] )
      @@blocks["search"].set( [1, 1], [2, -1] )
      @@blocks["result"].set( [3, 0], [0, 0] )
    end

    @@tabs["install"].set( [0, 0], [ size[0] - 2, size[1] ] ) do
      @@blocks["log"].set( [0, 0], [0, 0] )
      #@@frames[1].set( [0, size[1] / 2], [0, 0] ) do
      #  @@blocks["debug"].set( [1, 1], [-1, -1] )
      #end
    end

    @@navi.set( [ size[0] - 1, 0 ], [ size[0], size[1] ] )

    @@popups.each_with_index do |popup, index|

      round = (index + 4) / 10

      if round > 5
        round = round % 5 + 1
      end

      if round > 0
        index = (index + 4) % 10 - 4
      end

      popup.set([6 + index, 10 + index + round], [size[0] - 6 + index, size[1] - 10 + index + round])

    end

    App.render

  end

  def input

    Signal.trap 'SIGWINCH' do
      App.set
    end

    code = {
      "\e[3~"  => :delete,
      "\e[A"   => :key_up,
      "\e[B"   => :key_down,
      "\e[C"   => :key_right,
      "\e[D"   => :key_left,
      "\e[M "  => :mouse1_down,
      "\e[M\"" => :mouse2_down,
      "\e[M#"  => :mousex_up,
      "\e[M`"  => :scroll_up,
      "\e[Ma"  => :scroll_down,
      "\e[5~"  => :pg_up,
      "\e[6~"  => :pg_dn,
      "\e[H"   => :home,
      "\e[F"   => :end,
    }

    escape = String.new

    while ch = Curses.getch&.ord

      next if ch.nil? or ch == 410

      if escape.empty?

        case ch
        when 27
          escape << ch
          Curses.timeout = 0
          ch = Curses.getch
          Curses.timeout = -1
          if ch.nil?
            @@focus[-1]&.key :escape
            escape.clear
          else
            Curses.ungetch ch
          end
        when 3, 4
          App.quit
        when 8, 127
          @@focus[-1]&.key :backspace
        when 9
          @@focus[-1]&.key :tab
        when 10, 13
          @@focus[-1]&.key :enter
        else
          @@focus[-1]&.key ch
        end

      else

        if [27, 3, 4, 10, 13].include? ch
          escape.clear
          next
        end

        escape << ch.chr
        symbol  = code[escape]

        next if symbol.nil?

        if ["mouse", "scroll"].any? { |a| symbol.to_s.start_with? a }
          c = Curses.getch.ord - 33
          l = Curses.getch.ord - 33
          mouse symbol, [l, c]
        else
          @@focus[-1]&.key symbol
        end

        escape.clear

      end
    end

  end

  private

  def mouse type, pos

    case type
    when :scroll_down
      @@focus[-1].scroll 1
    when :scroll_up
      @@focus[-1].scroll -1
    when :mousex_up
    else

      try = @@popups.reverse + @@blocks.values
      blk = try.index do |b|
        \
          b.tl and b.br and !b.hide? and \
          b.tl[0] <= pos[0] and b.tl[1] <= pos[1] and \
          b.br[0] >  pos[0] and b.br[1] >  pos[1]
      end
      return if blk.nil?

      if @@popups.any? and blk >= @@popups.size
        @@focus.pop(@@popups.size)
        @@popups.clear
        set
        return
      end

      blk = try[blk]

      rel = [ pos[0] - blk.tl[0], pos[1] - blk.tl[1] ]

      begin
        foc = blk.click rel, type
      rescue
        foc = blk.click rel
      end

      focus blk if foc

    end

  end

end
