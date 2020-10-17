module IMP

  def start_daemon
    begin
      Daemon.new nil
      return true
    rescue
      return false
    end
  end

end
