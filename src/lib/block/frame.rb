# frozen_string_literal: true
class Frame < Block

  HORIZONTAL   = '─'
  VERTICAL     = '│'
  TOP_LEFT     = '┌'
  TOP_RIGHT    = '┐'
  BOTTOM_LEFT  = '└'
  BOTTOM_RIGHT = '┘'

  def initialize
    @title = ''
  end

  def update data
    @title = " #{data} "
    super
  end

  def display
    if @h == 1
      out HORIZONTAL * @w
    else
      out TOP_LEFT + HORIZONTAL + @title + HORIZONTAL * (@w - @title.length - 3) + TOP_RIGHT
      for i in (1 .. @h - 2)
        out VERTICAL + ' ' * (@w - 2) + VERTICAL
      end
      out BOTTOM_LEFT + HORIZONTAL * (@w - 2) + BOTTOM_RIGHT
    end
  end

end
