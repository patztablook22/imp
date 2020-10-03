class Progress

  attr_reader :head, :body, :status, :whole

  def initialize *data
  end

  def go!
  end

  def ok?
  end

end

Dir["#$git/src/lib/progress/*"].each do |prog|
  require_relative prog
end
