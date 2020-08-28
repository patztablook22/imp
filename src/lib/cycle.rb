module Cycle

  @@tasks = Array.new
  @@active

  def self.do! name
  end

  def do! name
  end

  # skip current cycle / phase
  # and delete it's log block
  def skip!
    Msg.del
    raise :skip
  end
  def get token
    @@field[token]
  end

  def set token, value
    @@field[token] = value
  end

  # delete entry
  def del
    Msg.del
  end

  # new entry
  def new
    Msg.new
  end
  # error
  def err str = nil
    Msg.err
  end

  # all complete
  def oki
    Msg.oki
  end

end
