# frozen_string_literal: true
class Navi < Block

  @@global = {'^C' => 'quit'}

  def update data
    if data.nil?
      local = @@global
    else
      local = @@global.merge data
    end
    return if @local == local
    @local = local
    super
  end

  def display
    @local&.each do |key, val|
      Curses.attron Curses.color_pair(2)
      out '    ', false
      Curses.attroff Curses.color_pair(2)
      Curses.attron Curses.color_pair(3)
      out key, false
      Curses.attroff Curses.color_pair(3)
      Curses.attron Curses.color_pair(2)
      out " #{val}", false
      Curses.attroff Curses.color_pair(2)
    end
    Curses.attron Curses.color_pair(2)
    out
    Curses.attroff Curses.color_pair(2)
  end

end
