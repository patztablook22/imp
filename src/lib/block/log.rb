class Log < Block

  def initialize
    @data = Array.new
  end

  def update data
    if data.nil?
      @data.clear
    else
      @data << data.to_s.strip
    end
    super
  end

  def focus
    App.navi "ESC" => "cancel"
  end

  def key ch
    if ch == :escape
      App.popup "cancel", "Stop installation?", {
        true  => -> { App.tab "search" },
        false => -> {},
      }
    end
  end

  def display
    return if hide?
    super
    for i in (1..@h)
      out
    end
    super
    first = true
    @data.last(@h).each do |l|
      if first
        first = false
      else
        out
      end
      out l, false
    end
    out "", false
  end

end
