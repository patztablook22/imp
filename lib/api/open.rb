module IMP

  def open
    return unless @@client.nil?
    begin
      @@client = Client.new
      return true
    rescue
      return false
    end
  end

  def close
    return if @@client.nil?
    @@client.close
    @@client = nil
    true
  end

end
