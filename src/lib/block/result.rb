# frozen_string_literal: true
class Result < Block

  def initialize
    @data = Array.new
    @pos  = 0
    @top  = 0
  end

  def update data

    case data
    when NilClass

      @data.clear
      @pos = 0
      @top = 0

    when Symbol

      if Env["tui"]
        App.popup "network error", "Check your connection..."
      else
        Cli[-1] = "network error"
      end

    when Array
      unless Env["tui"]
        data.each do |pkg|
          Cli[-1] = "#{pkg.name} (version #{pkg.version})"
        end
        return
      end

      return if data.none?

      size = @data.size
      @data += data

      if size == 0
        navi
      elsif size >= @top + @h
        bar
        App.render
        return
      end

    end

    super

  end

  def focus
    super
    if @data.none?
      App.navi
    else
      navi
    end
  end

  def unfocus
    super
    display
  end

  def key ch
    case ch
    when :escape
      App.focus "search"
      return
    when :key_up
      if @data.none? or @pos == 0 or @pos.nil?
        App.focus "search"
        return
      end
      @pos -= 1
      if @pos < @top
        @top -= 1
      end
    when :key_down
      return if @data.none?
      old = @pos
      @pos = @pos.to_i + 1
      if @pos >= @data.size
        @pos = old
        return
      end
    when :pg_up
      @top = [0, @top - @h / 2, @data.size - @h / 2].sort[1]
      @pos = @top
    when :pg_dn
      @top = [0, @top + @h / 2, @data.size - @h / 2].sort[1]
      @pos = [0, @top + @h / 2, @data.size - 1].sort[1]
    when :home
      @pos = 0
    when :end
      @pos = @data.size - 1
      @pos = 0 if @pos < 0
    when :key_left
    when :key_right
    when :enter

      if pkg = @data[@pos]

        state   = ""
        actions = Hash.new
        install = -> {
          App.tab "install"
          Plugin[pkg.plugin].install pkg.name
        }
        remove = -> {
          App.popup "remove", "Remove #{pkg.name}?", {
            true  => -> { Plugin[pkg.plugin].remove pkg.name },
            false => -> {},
          }
        }
        cancel = -> {
        }

        case pkg.sync!
        when nil
          state = "not installed"
          actions["install"] = install
          actions["cancel"]  = cancel
        when false
          state = "needs update"
          actions["cancel"] = cancel
          actions["update"] = install
          actions["remove"] = remove
        when true
          state = "up to date"
          actions["cancel" ] = cancel
          actions["remove"] = remove
        end

        body = "
        #{pkg.version}
        #{state}
        #{pkg.plugin}
        #{pkg.desc}
        "

        App.popup pkg.name, body, actions

        return

      end

    end

    App.render

  end

  def scroll lines
    @top += lines
    @top  = [ 0   , @top, @data.size - @h / 2 ].sort[1]
    @top  = 0 if @top < 0
    @pos  = [ @top, @pos, @top + @h / 2 - 1   ].sort[1]
    display
  end

  def click pos
    if pos[1] < @w - 1
      pos = @top + pos[0] / 2
      if @pos == pos and @focus
        key :enter
        false
      else
        @pos = pos
      end
    else
      return if @data.none?
      @top  = pos[0] * @data.size / @h - @h ** 2 / @data.size / 4
      @top += 1 unless @top == 0
      @top  = [0, @top, @data.size - @h / 2].sort[1]
      @pos  = @top
    end
  end

  def display

    return if hide?
    super

    if @top < (@pos - @h / 2 ) + 1
      @top = (@pos - @h / 2) + 1
    elsif @top > @pos
      @top = @pos
    end

    @data[@top ... @top + @h / 2].each_with_index do |pkg, n|

      highlight = ( @focus and @pos == @top + n )
      name      = pkg.name
      version   = "version #{pkg.version}"
      space     = @w - 2 - name.length - version.length
      space     = 0 if space < 0

      Curses.attron Curses.color_pair(3) if highlight
      out name, false
      Curses.attron Curses::A_DIM
      out " " * space + version
      out "." * (@w - 2)
      Curses.attroff Curses::A_DIM
      Curses.attroff Curses.color_pair(3) if highlight

    end

    out until @p[0] >= @h

    bar

  end

  private

  def bar

    if @data.none?
      for i in (0...@h)
        move [i, @w - 2]
        out "  ", false
      end
      return
    end

    p = @h * @top / @data.size
    h = @h ** 2 / @data.size / 2

    for i in (0...@h)

      move [i, @w - 2]
      Curses.attron Curses.color_pair 4
      if i >= p and i <= p + h
        out " █", false
      else
        out " │", false
      end
      Curses.attroff Curses.color_pair 4

    end

  end

  private

  def navi
    App.navi "ENTER" => "install" 
  end

end
