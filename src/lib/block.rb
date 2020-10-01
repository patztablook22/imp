# frozen_string_literal: true
class Block

  @tl  # position top left [line, col]
  @br  # position bottom right ...
  @h   # height
  @w   # width
  @p   # position within block [line, col]

  attr_reader :tl, :br

  @child # child blocks
  @focus # focused?
  @hide  # hide?

  @@tlContext   = [0, 0]
  @@brContext   = [0, 0]
  @@hideContext = nil

  def move *args

    if args[0].class == Array
      
      p = args[0]

      if p[0] >= 0
        @p[0] = p[0]
      else
        @p[0] = @h + p[0]
      end

      if p[1] >= 0
        @p[1] = p[1]
      else
        @p[1] = @w + p[1]
      end

    elsif args[1] == :vertical   and args[1].class == Integer
      @p[0] += args[1]
    elsif args[0] == :horizontal and args[1].class == Integer
      @p[1] += args[1]
    end

  end

  def out str = '', newline = true

    return if @hide or @p[0] >= @h
    return if @p[1] >= @w
    str = str.to_s[0...@w - @p[1]]

    Curses.setpos(@tl[0] + @p[0], @tl[1] + @p[1])

    if newline

      Curses.addstr str + ' ' * (@w - @p[1] - str.length)

      @p[0] += 1
      @p[1]  = 0

    else

      Curses.addstr str

      @p[1] += str.length

=begin
      if @p[1] >= @w
        @p[0] += 1
        @p[1]  = 0
      end
=end

    end

  end

  def hide?
    @hide
  end

  def hide= val
    @hide = val
  end

  def set tl, br, &child

    @tl = Array.new
    @br = Array.new

    @tl[0] = @@tlContext[0] + tl[0]
    @tl[1] = @@tlContext[1] + tl[1]

    if br[0] > 0
      @br[0] = @@tlContext[0] + br[0]
    else
      @br[0] = @@brContext[0] + br[0]
    end

    if br[1] > 0
      @br[1] = @@tlContext[1] + br[1]
    else
      @br[1] = @@brContext[1] + br[1]
    end

    if @@hideContext.nil?
      @hide = false if @hide.nil?
    else
      @hide = @@hideContext
    end

    @h = @br[0] - @tl[0]
    @w = @br[1] - @tl[1]

    reset
    display unless @hide

    @child = child unless child.nil?

    tlOld   = @@tlContext
    brOld   = @@brContext
    hideOld = @@hideContext

    @@tlContext   = @tl
    @@brContext   = @br
    @@hideContext = @hide

    @child&.call

    @@tlContext   = tlOld
    @@brContext   = brOld
    @@hideContext = hideOld

  end

  def reset
    @p = [0, 0]
  end

  def update data
    return if @p.nil?
    reset
    display unless @hide
    App.render
  end

  def focus
    @focus = true
  end

  def unfocus
    @focus = false
  end

  def key ch
  end

  def click pos, type
    true # focus on this block?
  end

  def scroll lines
  end

  private

  def display
    reset
  end

end

Dir["#$git/src/lib/block/*"].each do |blk|
  require_relative blk
end
