# frozen_string_literal: true
require_relative 'tab'
require_relative 'loading'

class Intro < Tab

  @@txt = "
$$\\                         $$\\ 
\\__|                        $$ |
$$\\ $$$$$$\\$$$$\\   $$$$$$\\  $$ |
$$ |$$  _$$  _$$\\ $$  __$$\\ $$ |
$$ |$$ / $$ / $$ |$$ /  $$ |\\__|
$$ |$$ | $$ | $$ |$$ |  $$ |    
$$ |$$ | $$ | $$ |$$$$$$$  |$$\\ 
\\__|\\__| \\__| \\__|$$  ____/ \\__|
                  $$ |          
                  $$ |          
                  \\__|
  "

  def initialize
    @open = false
    @step = 0
    @stop = 0
  end

  def update data
    if data.nil?
      @open = true
      App.navi "ENTER" => "continue"
    else
      @step = data[0]
      @stop = data[1]
    end
    super
  end

  def key ch
    return unless @open
    case ch
    when :enter
      Cache["intro"] = 1
      App.tab "search"
    end
  end

  def display

    lines  = @@txt.split("\n")
    width  = lines[2].length
    height = lines.size
    space  = " " * ((@w - width) / 2)

    for i in (0 .. (@h - height) / 2)
      out
    end

    @@txt.each_line do |it|
      out space + it
    end

    return if @stop == 0

    move [-3, @w / 4 - 2]
    out "[ " + Loading.percent( 100 * @step / @stop , @w / 2 ) + " ]"

  end

end
