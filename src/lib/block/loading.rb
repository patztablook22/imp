class Loading < Block

  FULL = "█"
  HALF = "|"
  NONE = " "

  def self.percent p, w

    buf = String.new

    fulls = w * p / 100
    fulls = fulls.to_i

    for i in (1..fulls)
      buf << FULL
    end

    buf << HALF unless fulls * 100 == w * p
    buf << NONE * (w - buf.length)

    buf

  end

end
